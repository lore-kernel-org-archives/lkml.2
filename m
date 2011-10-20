Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1JTBBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 21:01:52 -0400
Received: from shawmail.shawcable.com ([64.59.128.220]:13088 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab1JTBBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 21:01:51 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=l0hTUOwXBBZC3xuFbE1ochJnP84ph5EBJB8ZSEz2E7A= c=1 sm=1
 a=CSHQtCKG1fQA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=SOq6UgPBAAAA:8 a=VwQbUJbxAAAA:8
 a=AbMvaSVIJi3zZKyypecA:9 a=07QDKq3cAmvwtKJbznEA:7 a=CjuIK1q_8ugA:10
 a=GggyOlg3CnYA:10 a=MlDzmOR2rr8A:10 a=CHvbGjLrMYgA:10 a=MRfdvb_iZmAA:10
 a=x8gzFH9gYPwA:10 a=5y_flRe8UpcA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.69,375,1315202400"; 
   d="scan'208";a="483120083"
X-reinject: true
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
In-Reply-To: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
X-Mailer: iPhone Mail (8L1)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Latency writing to an mlocked ext4 mapping
Date: Wed, 19 Oct 2011 19:02:46 -0600
To: Andy Lutomirski <luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What kernel are you using?  A change to keep pages consistent during writeout was landed not too long ago (maybe Linux 3.0) in order to allow checksumming of the data. 

We discussed doing copy-on-write, but there are relatively few mmap users and it wasn't clear whether the complexity was worth it. 

Cheers, Andreas

On 2011-10-19, at 6:39 PM, Andy Lutomirski <luto@amacapital.net> wrote:

> I have a real-time program that has everything mlocked (i.e.
> mlockall(MCL_CURRENT | MCL_FUTURE)).  It has some log files opened for
> writing.  Those files are opened and memset to zero in another thread
> to fault everything in.  The system is under light I/O load with very
> little memory pressure.
> 
> Latencytop shows frequent latency in the real-time threads.  The main
> offenders are:
> 
> schedule sleep_on_page wait_on_page_bit ext4_page_mkwrite do_wp_page
> handle_pte_fault handle_mm_fault do_page_fault page_fault
> 
> schedule do_get_write_access jbd2_journal_get_write_access
> __ext4_journal_get_write_access ext4_reserve_inode_write
> ext4_mark_inode_dirty ext4_dirty_inode __mark_inode_dirty
> file_update_time do_wp_page handle_pte_fault handle_mm_fault
> 
> 
> I imagine the problem is that the system is periodically writing out
> my dirty pages and marking them clean (and hence write protected).
> When I try to write to them, the kernel makes them writable again,
> which causes latency either due to updating the inode mtime or because
> the file is being written to disk when I try to write to it.
> 
> Is there any way to prevent this?  One possibility would be a way to
> ask the kernel not to write the file out to disk.  Another would be a
> way to ask the kernel to make a copy of the file when it writes it
> disk and leave the original mapping writable.
> 
> Obviously I can fix this by mapping anonymous memory, but then I need
> another thread to periodically write my logs out to disk, and if that
> crashes, I lose data.
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> Office: (310) 553-5322
> Mobile: (650) 906-0647
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
