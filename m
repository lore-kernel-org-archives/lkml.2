Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0F2Use (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:48:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0F2Usd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=BqNzTdxK7txIKhfjzdXdLqNLdAXlb3jTyeKwZRkzSxNrfcJlmsYHRp22Il4VRZMZC1
         UN1AXwUP8vA6+ArKbRhdjmLkJRcHINDVAEAiK4wCORhvD6RMsMEdZvr7WggqeOiM3T9R
         PBdNJYsr/Ik2wodV5AXvb5tDQYzQNTmSiMBDs=
MIME-Version: 1.0
Date: Tue, 29 Jun 2010 13:48:31 -0700
Message-ID: <AANLkTikgMbxsivH__PDrbOIi8biVDCqf26Is5RWENB9d@mail.gmail.com>
Subject: Length and alignment in scsi_execute_async and blk_rq_map_user
From: Brett Dennis <brettldennis@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Question for linux-scsi: In kernel 2.6.26, the implementation of
__blk_rq_map_user changed and now includes a call to bio_copy_user:

uaddr = (unsigned long) ubuf;
alignment = queue_dma_alignment(q) | q->dma_pad_mask;
if (!(uaddr & alignment) && !(len & alignment))

bio = bio_map_user(q, NULL, uaddr, len, reading);

else

bio = bio_copy_user(q, uaddr, len, reading);


bio_copy_user uses the HBA's scatter-gather pages for the copy.  The
problem I face is that if the data size is not aligned properly, or
the len parameter does not divide properly, and the transfer is
greater than the number of scatter-gather pages, the IO operation will
fail.  I am considering increasing the size of my data buffer to meet
the length-alignment requirement and changing the 'len' parameter
passed into blk_rq_map_user to include a larger size than my CDB
transfer length.  The tape device should still honor the CDB write
length, so unless there are other limitations imposed by the Linux
kernel or SCSI subsystem, I think this is a workable solution.  Does
anyone in this list know if there is are requirements against sending
a larger buffer length than CDB transfer length?

Thanks in advance.

Brett Dennis
IBM tape device driver developer
