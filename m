Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0CYR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:28:57 -0400
Received: from daytona.panasas.com ([67.152.220.89]:12392 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938Ab0CYR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:28:55 -0400
Message-ID: <4BAB9D53.4000909@panasas.com>
Date: Thu, 25 Mar 2010 19:28:51 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <20100325101231.GU30031@ZenIV.linux.org.uk> <20100325105406.GW30031@ZenIV.linux.org.uk> <4BAB51F5.609@panasas.com> <4BAB54B0.3080109@panasas.com> <20100325130610.GZ30031@ZenIV.linux.org.uk> <4BAB656E.8020204@panasas.com> <20100325133746.GA30031@ZenIV.linux.org.uk> <4BAB6911.5020009@panasas.com> <20100325140457.GB30031@ZenIV.linux.org.uk> <4BAB72C1.6090002@panasas.com> <20100325152505.GD30031@ZenIV.linux.org.uk>
In-Reply-To: <20100325152505.GD30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 17:28:54.0367 (UTC) FILETIME=[A4858EF0:01CACC40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 05:25 PM, Al Viro wrote:
> On Thu, Mar 25, 2010 at 04:27:13PM +0200, Boaz Harrosh wrote:
>  
>> And about the NFS thing, let misbehaving applications byte there own bullets.
>> But a good app like git, does put an O_DIRECTORY on the directory open, and
>> therefore will receive consistent results, right?
> 
> What the hell do you mean, "misbehaving"?  O_DIRECTORY means one thing:
> "refuse to open if it turns out to be a non-directory".  If open() succeed
> with it and fails without, it's a definite bug.  Application has every
> right to call the damn thing without that flag.
> 

Ha, OK, sorry I thought exactly the opposite. I assumed it meant
"don't allow a directory to be opened, unless set". As an application
hint of saying I'm going to do file things to this handle, don't want
any dirs.

So yes definitely it looks like an NFS bug masked by the fact that everyone
is using opendir() form libc for this.

> It *can* be used as a hint by fs code, and it's a useful hint, so yes,
> we need to restore LOOKUP_DIRECTORY (until we get rid of the entire
> d_revalidate/lookup+open mess and pass struct file + open flags directly
> to fs method for the last step of pathname resolution; basically, most
> of the do_last() guts would become that method, killing the intents
> crap for good; new method would simply check for O_DIRECTORY presence
> instead of looking at LOOKUP_DIRECTORY).
> 
> However, NFS behaviour in cases when O_DIRECTORY is absent is a separate
> (and quite real) bug.  If nfs_atomic_lookup() sees -EISDIR from attempt
> to open on server, it should either issue plain lookup or try to use the
> information it got in response to open attempt (if there's enough of it
> there).  Passing -EISDIR to ->lookup() caller is simply wrong.
> 
> I'm going to send a fix for O_DIRECTORY case (restoring the behaviour
> we had in 2.6.33) today, but NFS side of things also needs to be dealt
> with.

Thank you Al for fixing this, I hope some capable NFS person will take
that issue to heart.

Boaz
