Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0CYPZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:25:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab0CYPZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:25:07 -0400
Date: Thu, 25 Mar 2010 15:25:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325152505.GD30031@ZenIV.linux.org.uk>
References: <20100325101231.GU30031@ZenIV.linux.org.uk>
 <20100325105406.GW30031@ZenIV.linux.org.uk>
 <4BAB51F5.609@panasas.com>
 <4BAB54B0.3080109@panasas.com>
 <20100325130610.GZ30031@ZenIV.linux.org.uk>
 <4BAB656E.8020204@panasas.com>
 <20100325133746.GA30031@ZenIV.linux.org.uk>
 <4BAB6911.5020009@panasas.com>
 <20100325140457.GB30031@ZenIV.linux.org.uk>
 <4BAB72C1.6090002@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB72C1.6090002@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 04:27:13PM +0200, Boaz Harrosh wrote:
 
> And about the NFS thing, let misbehaving applications byte there own bullets.
> But a good app like git, does put an O_DIRECTORY on the directory open, and
> therefore will receive consistent results, right?

What the hell do you mean, "misbehaving"?  O_DIRECTORY means one thing:
"refuse to open if it turns out to be a non-directory".  If open() succeed
with it and fails without, it's a definite bug.  Application has every
right to call the damn thing without that flag.

It *can* be used as a hint by fs code, and it's a useful hint, so yes,
we need to restore LOOKUP_DIRECTORY (until we get rid of the entire
d_revalidate/lookup+open mess and pass struct file + open flags directly
to fs method for the last step of pathname resolution; basically, most
of the do_last() guts would become that method, killing the intents
crap for good; new method would simply check for O_DIRECTORY presence
instead of looking at LOOKUP_DIRECTORY).

However, NFS behaviour in cases when O_DIRECTORY is absent is a separate
(and quite real) bug.  If nfs_atomic_lookup() sees -EISDIR from attempt
to open on server, it should either issue plain lookup or try to use the
information it got in response to open attempt (if there's enough of it
there).  Passing -EISDIR to ->lookup() caller is simply wrong.

I'm going to send a fix for O_DIRECTORY case (restoring the behaviour
we had in 2.6.33) today, but NFS side of things also needs to be dealt
with.
