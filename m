Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2CHWP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:15:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37636 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab2CHWP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:15:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <20120130222717.GA6393@kroah.com>
	<m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz>
	<m14nvc82jo.fsf@fess.ebiederm.org>
	<CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	<m1wr87ywex.fsf@fess.ebiederm.org>
	<m1ehueyz20.fsf_-_@fess.ebiederm.org>
	<CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	<CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	<4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
	<CA+55aFy1PXiNkXw08tDM7G9AO0_92xm2mEFF961-4Wpizo+6KQ@mail.gmail.com>
Date: Thu, 08 Mar 2012 14:18:47 -0800
In-Reply-To: <CA+55aFy1PXiNkXw08tDM7G9AO0_92xm2mEFF961-4Wpizo+6KQ@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 5 Mar 2012 08:47:27 -0800")
Message-ID: <m1zkbqu46w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/O7sLDwpDAqn47z+1sFj5yUtxSP4uxCdk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy applications
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Mar 5, 2012 at 8:09 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> I don't remember.  I thought there was a proposed patch for this issue
>> from Eric, but I don't see it in my queue anywhere.
>
> That patch was an abortion. Adding a config option for behavior like
> this is totally bogus, and the only reason for that config option was
> that sysfs did silly things.

The biggest reason it is bogus is that it doesn't get properly tested
or reviewed.  Sigh.  My first patch to fix things had a bad typo
that everyone missed.

> It's only in -next, though, I was assuming that the whole "Kill nlink
> counting" commit never makes it to me. Because I won't take it.
>
> I outlined how the counting could easily be done without actually
> having to maintain an explicit count in the sysfs.

And if you had bothered to look you would have seen how we used to
have that code and it was removed because it was a performance
bottleneck.

> Or we should just keep doing the counting.

The current counting that we do gives the wrong numbers, in the
edge cases.  To my knowledge a deleted sysfs directory has never
returned nlink == 0.

Keeping compatibility is easy enough that it looks like it is worth
doing, but maintaining 30+ years of backwards compatibility is what
nlink >1 in unix filesystem directories is.  I don't see any practical
sense in keeping . and .. directories on disk or upping the unix
nlink directory count because of them.  To me it looks like just one
of those things you do.  Like hash directory entries so you can
have a big directory and still be able to have a 32bit offset you
can pass to lseek that is stable across renames and deletes.

>From the point of view of maintaining sysfs a 32bit nlink_t in sysfs is
too small.  It is wrong for sysfs to refuse to represent devices that
exist and I have heard of machines that have enough memory it possible
to create more than 2^32 network devices.  So sysfs must handle overflow
and sysfs must use the nlink == 1 in some cases.  I was just thinking
we would get better userspace test coverage if we don't bother to handle
the other cases.

Eric
