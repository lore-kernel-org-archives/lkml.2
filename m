Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab0E0KNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:13:09 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:34831 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0E0KNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:13:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dY4gJdsm6M18xQ31WvvHD5Z1qPJvGMzycCCtt8m1VxA6hfeiwEhs+W1vK4BZ3VFzBz
         aKmkX9IfL6NXRZqkdKnTKk2VxvVXi8zrh9K+x2JzehT+8iKTchr+psjM1vUP9tNiZLys
         NEn5Z5vCo4vlU8A2/H4dqiUCyn+lemg6bVi5I=
Date: Thu, 27 May 2010 12:07:29 +0200
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: linux-kernel@vger.kernel.org
Subject: hex_to_bin speedup
Message-ID: <20100527100729.GA21454@iveqy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I looked a bit at the newly added hex_to_bin function in lib/hexdump.c.
I do believe this is a speedup (at least according to my benchmark[1]).

However in the comments to commit 
903788892ea0fc7fcaf7e8e5fac9a77379fc215b you can read
"[akpm@linux-foundation.org: use tolower(), saving 3 bytes, test the more common case first - it's quicker]"

I don't know the change that akpm has done, so I'm unsure if there's any
problems that I miss with my patch.

--
iveqy

[1] Benchmark

#include <sys/time.h>
#include <stdio.h>

int main()
{
	struct timeval start, end;
	int i,itr;
	itr = 100000;
	char c = 'A';
	time_t diff;
	gettimeofday(&start,NULL);
	for(i = 0; i < itr; i++) {
		if((c >= 'A') && (c <= 'F')) {}
	}
	gettimeofday(&end,NULL);
	diff = end.tv_usec - start.tv_usec;
	printf("if-statement: %d ms\n",diff);
	gettimeofday(&start,NULL);
	for(i = 0; i < itr; i++) {
		c = tolower(c);
	}
	gettimeofday(&end,NULL);
	diff = end.tv_usec - start.tv_usec;
	printf("tolower(): %d ms\n",diff);
}

[2] Patch

This is faster (at least on i686).
---
 lib/hexdump.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 5d7a480..f01d11c 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -26,9 +26,10 @@ int hex_to_bin(char ch)
 {
 	if ((ch >= '0') && (ch <= '9'))
 		return ch - '0';
-	ch = tolower(ch);
 	if ((ch >= 'a') && (ch <= 'f'))
 		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
 	return -1;
 }
 EXPORT_SYMBOL(hex_to_bin);
