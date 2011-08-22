Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1HVNdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:33:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33421 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1HVNdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110822132713.GT2203@ZenIV.linux.org.uk>
References: <4E51CFD8.2090508@gmail.com>
	<CA+5PVA6KUMDEygjxrqwvpRDNfJ3WobUs7rwyP+pZrX9-atZUgw@mail.gmail.com>
	<20110822131621.GS2203@ZenIV.linux.org.uk>
	<20110822132713.GT2203@ZenIV.linux.org.uk>
Date: Mon, 22 Aug 2011 09:33:34 -0400
Message-ID: <CA+5PVA5NE1Om9SK-UoA-RBH56RP-MLrNdiMVAVQx8LFaBdxaYg@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency detected 3.1.0-rc2-00190-g3210d19
From: Josh Boyer <jwboyer@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 9:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Aug 22, 2011 at 02:16:21PM +0100, Al Viro wrote:
>> On Mon, Aug 22, 2011 at 09:09:14AM -0400, Josh Boyer wrote:
>>
>> > We've had a report of this on 3.0.1 as well.  Slightly different
>> > scenario and fs, but the locks in question are the same.
>> > https://bugzilla.redhat.com/show_bug.cgi?id=730998
>> >
>> > It seems that with CONFIG_PROVE_LOCKING on, might_fault will always
>> > attempt to grab mm->mmap_sem.  The common flow here is that getdents
>> > calls filldir, which calls copy_to_user, which is what is calling
>> > might_fault.
>> >
>> > Beyond that, I'm a bit over my head at the moment because I don't know
>> > if the VFS is right and we just need some more lockdep annotations or
>> > if there really is a problem.
>>
>> Don't grab ->i_mutex in ->evict_inode().  Why are you doing that, anyway?
>
> Note, BTW, that readdir() is a red herring here; there is a much more
> relevant reason for that ranking.  Namely, write() doing copy_from_user()
> when the file we are writing into has i_mutex held by us.  That can fault
> and in this case we have a non-directory inode.  While you can't have
> directory mmapped, regular files can be mmapped just fine.

So the lockdep report in the RHBZ (which now that I look at it
probably isn't the same as this report) seems to be doing a readdir
while find is trying to mmap, which is calling into
hugetlbfs_file_mmap and throwing the same deadlock warning.  Is that
like the scenario you are describing above?

josh
