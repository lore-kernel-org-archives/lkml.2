Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0GLCno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:43:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39001 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab0GLCnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=K3ZPHi6g95HP4SBO5kCUg3LlAu9NAZuNaeCvAhafJ3lrU/InxfLNl3Z8oFmORvE57x
         39RDE0eNSfHYBasOvvfhfgtxrn2R2lisQmzw563wKG0B+pCRkdaU32IskPlay2LyDB0T
         OQbbxSPWjs6WJpCkx/peI/h2KKM+0xB8bjVPg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikk1GolPUM5YT8akhd9S8UAdQ6jUm6pSmCEVC1r@mail.gmail.com>
References: <AANLkTikk1GolPUM5YT8akhd9S8UAdQ6jUm6pSmCEVC1r@mail.gmail.com>
Date: Mon, 12 Jul 2010 10:43:41 +0800
Message-ID: <AANLkTikq8jS6fK_VakFCQkYZtS3AprMMHDA6PnjAZGa7@mail.gmail.com>
Subject: One question about the positions of flush_dcache_page and 
	bounce_copy_vec methods in copy_to_high_bio_irq
From: qingyuan huang <qingyuan82.huang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Recently, I read the kernel codes from 2.6.32 to 2.6.35. I have a
question about the positions of flush_dcache_page and bounce_copy_vec
methods in copy_to_high_bio_irq function in mm/bounce.c file. In my
opinion, flush_dcache_page is written before bounce_copy_vec in order
to set the destination page in bounce_copy_vec  PG_dcache_dirty bit in
some platforms which have not hardware cache coherence protocol. But
when I read the flush_dcache_page codes in ARM and MIPS, I found there
could be some exceptions in this function copy_to_high_bio_irq. Take
ARM as a example, the flush_dcache_page in ARM platform has two
execution paths:
path1: set_bit(PG_dcache_dirty, &page->flags) (deffer flushing until
in update_mmu_cache)
path2: __flush_dcache_page (mapping, page); if(mapping) __flush_icache_all();
If the codes run in path2 not path1, because the cache is flushed
before copy operation , it could make a mistake in
copy_to_high_bio_irq function. At this situation, the I/D cache could
be incoherent, and the system could run the bad instructions in i
cache. If we switch the positions of the two funcitons, we could not
meet this qustion and it could not lower the performance.
