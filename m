Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0KWOu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:50:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63890 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0KWOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZdrY/YP9q93G9ivSZV31o/C1uCIoWnTt6lI58iNcobR0We8znjl89bRfv41PP5iOeo
         w0NkuDKyMg5oKyjA9btnsqF6whu1Olr8E+ZetdnbPlptgbSi+EQGPxHu3AdG29GUTJDI
         0F5u5b0ZYfaw8fwdhqHFLJeZXtaKDU/+P69kM=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, rsync@lists.samba.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Ben Gamari <bgamari.foss@gmail.com>
Subject: [PATCH 3/3] Inform kernel of FADV_DONTNEED hint in receiver
Date: Tue, 23 Nov 2010 09:49:52 -0500
Message-Id: <1290523792-6170-4-git-send-email-bgamari.foss@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101122103756.E236.A69D9226@jp.fujitsu.com>
References: <20101122103756.E236.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the FADV_DONTNEED fadvise hint after finishing writing to a
destinataion fd in the receiver.
---
 receiver.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/receiver.c b/receiver.c
index 39c5e49..33b21fb 100644
--- a/receiver.c
+++ b/receiver.c
@@ -721,6 +721,12 @@ int recv_files(int f_in, char *local_name)
 		recv_ok = receive_data(f_in, fnamecmp, fd1, st.st_size,
 				       fname, fd2, F_LENGTH(file));
 
+                if (do_fadvise(fd2, 0, 0, POSIX_FADV_DONTNEED) != 0) {
+                        rsyserr(FERROR_XFER, errno,
+                                "fadvise failed in writing %s",
+                                full_fname(fname));
+                }
+
 		log_item(log_code, file, &initial_stats, iflags, NULL);
 
 		if (fd1 != -1)
-- 
1.7.1

