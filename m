Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1AHL6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 06:58:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50347 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1AHL6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 06:58:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=BoUeJ390Yu9YLOEpkgjgMjklH5A48K5bLriH+xuUYU6onEW9olmBoL+GINmQtrQXPo
         jTTU9PGEc/XKlcHDG3qY8MSAXSjYDGYYVGVGmv4/kk18ujsEK9ENqnBYnWmjCYCwYhY/
         l/3zkK/f8rID38WLYUIZhraYHfmZH9zaNiyoM=
Message-ID: <4D285158.1080804@gmail.com>
Date: Sat, 08 Jan 2011 06:58:16 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [058/152] tcp: protect sysctl_tcp_cookie_size reads
References: <20110106002302.141581701@clark.site>	<4D2691D4.3060304@gmail.com>	<1294389025.2704.95.camel@edumazet-laptop>	<4D270F85.9070705@gmail.com> <AANLkTinkmnVLi7NrKsK50MBsycyYhyvEdtm01NA9ubOX@mail.gmail.com>
In-Reply-To: <AANLkTinkmnVLi7NrKsK50MBsycyYhyvEdtm01NA9ubOX@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080802060801050500010402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080802060801050500010402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/11 8:36 AM, Pekka Enberg wrote:
> On Fri, Jan 7, 2011 at 3:05 PM, William Allen Simpson
> <william.allen.simpson@gmail.com>  wrote:
>> My instructors would have flunked me for not including braces around
>> multi-line sequences; it was one of the great no-no's of the '70s.  Perhaps
>> that's not the case anymore with modern colorful visual syntax checkers?
>
> That's because your instructors hadn't read Documentation/CodingStyle
> which didn't appear until the '90s.
>
Hi, Pekka.

OTOH, I *have* read Documentation/CodingStyle a cople year back, and then
re-checked it again today....  Out of curiosity, as I haven't done a Linux
patch in many months, I cloned linux-2.6 and checked out v2.6.36-rc8 (I don't
know where 2.6.36-stable is kept).

Note this patch is cleaner and more readable; lines that are changed have
one-to-one correspondence.

Eric was *not* *truthful* saying there were "checkpatch.pl errors/warnings" in
my code.

===

scripts/checkpatch.pl ~/sysctl_tcp_cookie_size-read-once.patch
total: 0 errors, 0 warnings, 36 lines checked

/home/test/sysctl_tcp_cookie_size-read-once.patch has no obvious style
problems and is ready for submission.

--------------080802060801050500010402
Content-Type: text/plain; x-mac-type="54455854"; x-mac-creator="0";
 name="sysctl_tcp_cookie_size-read-once.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sysctl_tcp_cookie_size-read-once.patch"

>From bd6f04cbee4c924e07cf3a1819a24acc3cc2490b Mon Sep 17 00:00:00 2001
From: William Allen Simpson <william.allen.simpson@gmail.com>
Date: Sat, 8 Jan 2011 05:58:21 -0500
Subject: [PATCH] sysctl_tcp_cookie_size read once

Read sysctl_tcp_cookie_size only once in tcp_cookie_size_check(),
as it might be concurrently changed by another cpu.

Signed-off-by: William.Allen.Simpson@gmail.com
---
 net/ipv4/tcp_output.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index de3bd84..49be4e3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -392,27 +392,30 @@ struct tcp_out_options {
  */
 static u8 tcp_cookie_size_check(u8 desired)
 {
+	int cookie_size;
+
 	if (desired > 0) {
 		/* previously specified */
 		return desired;
 	}
-	if (sysctl_tcp_cookie_size <= 0) {
+	cookie_size = ACCESS_ONCE(sysctl_tcp_cookie_size);
+	if (cookie_size <= 0) {
 		/* no default specified */
 		return 0;
 	}
-	if (sysctl_tcp_cookie_size <= TCP_COOKIE_MIN) {
+	if (cookie_size <= TCP_COOKIE_MIN) {
 		/* value too small, specify minimum */
 		return TCP_COOKIE_MIN;
 	}
-	if (sysctl_tcp_cookie_size >= TCP_COOKIE_MAX) {
+	if (cookie_size >= TCP_COOKIE_MAX) {
 		/* value too large, specify maximum */
 		return TCP_COOKIE_MAX;
 	}
-	if (0x1 & sysctl_tcp_cookie_size) {
+	if (cookie_size & 0x1) {
 		/* 8-bit multiple, illegal, fix it */
-		return (u8)(sysctl_tcp_cookie_size + 0x1);
+		cookie_size += 0x1;
 	}
-	return (u8)sysctl_tcp_cookie_size;
+	return (u8)cookie_size;
 }
 
 /* Write previously computed TCP options to the packet.
-- 
1.7.1


--------------080802060801050500010402--
