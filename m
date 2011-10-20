Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1JTBQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 21:16:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33229 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1JTBP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 21:15:59 -0400
MIME-Version: 1.0
In-Reply-To: <ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
	<ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
Date: Wed, 19 Oct 2011 18:15:59 -0700
Message-ID: <CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
Subject: Re: Latency writing to an mlocked ext4 mapping
From: Andy Lutomirski <luto@amacapital.net>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 6:02 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> What kernel are you using?  A change to keep pages consistent during writeout was landed not too long ago (maybe Linux 3.0) in order to allow checksumming of the data.

3.0.6, with no relevant patches.  (I have a one-liner added to the tcp
code that I'll submit sometime soon.)  Would this explain the latency
in file_update_time or is that a separate issue?  file_update_time
seems like a good thing to make fully asynchronous (especially if the
file in question is a fifo, but I've already moved my fifos to tmpfs).

>
> We discussed doing copy-on-write, but there are relatively few mmap users and it wasn't clear whether the complexity was worth it.

Hmm.  That might be nice, especially if the page is mlocked.

--Andy

>
> Cheers, Andreas
>
> On 2011-10-19, at 6:39 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
>> I have a real-time program that has everything mlocked (i.e.
>> mlockall(MCL_CURRENT | MCL_FUTURE)).  It has some log files opened for
>> writing.  Those files are opened and memset to zero in another thread
>> to fault everything in.  The system is under light I/O load with very
>> little memory pressure.
>>
>> Latencytop shows frequent latency in the real-time threads.  The main
>> offenders are:
>>
>> schedule sleep_on_page wait_on_page_bit ext4_page_mkwrite do_wp_page
>> handle_pte_fault handle_mm_fault do_page_fault page_fault
>>
>> schedule do_get_write_access jbd2_journal_get_write_access
>> __ext4_journal_get_write_access ext4_reserve_inode_write
>> ext4_mark_inode_dirty ext4_dirty_inode __mark_inode_dirty
>> file_update_time do_wp_page handle_pte_fault handle_mm_fault
>>
>>
>> I imagine the problem is that the system is periodically writing out
>> my dirty pages and marking them clean (and hence write protected).
>> When I try to write to them, the kernel makes them writable again,
>> which causes latency either due to updating the inode mtime or because
>> the file is being written to disk when I try to write to it.
>>
>> Is there any way to prevent this?  One possibility would be a way to
>> ask the kernel not to write the file out to disk.  Another would be a
>> way to ask the kernel to make a copy of the file when it writes it
>> disk and leave the original mapping writable.
>>
>> Obviously I can fix this by mapping anonymous memory, but then I need
>> another thread to periodically write my logs out to disk, and if that
>> crashes, I lose data.
>>
>> --
>> Andy Lutomirski
>> AMA Capital Management, LLC
>> Office: (310) 553-5322
>> Mobile: (650) 906-0647
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
