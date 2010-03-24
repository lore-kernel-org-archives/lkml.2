Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0CXXf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:35:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59425 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab0CXXfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UX6QHZ8A06nxMDfMBImNF85x64oVKEmb1sPMlA0xHiKwP9czOEt3TWCdGnerUtDyzU
         ZG+GU/WMNu46lqqSlUGINccJlS+HGKnHxnLcEyN37gP9CHLrB+jYI9gxKYxEC1aI2hdU
         1DtAS/tYedNJfPaoO+djpwFS+eddQ0ZIzrXcg=
MIME-Version: 1.0
In-Reply-To: <g76h4xrt5j1pw2kk3tUYAxe124vaj_firegpg@mail.gmail.com>
References: <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>
	 <g76h4xrt5j1pw2kk3tUYAxe124vaj_firegpg@mail.gmail.com>
Date: Wed, 24 Mar 2010 18:35:23 -0500
Message-ID: <84621a61003241635h65687366t6b28148281d529c9@mail.gmail.com>
Subject: Re: behavior of recvmmsg() on blocking sockets
From: Brandon Black <blblack@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 1:34 PM,  <drepper@gmail.com> wrote:
> On Wed, Mar 24, 2010 at 11:28, Brandon Black <blblack@gmail.com> wrote:
>>
>> I still think having a "block until at least one packet arrives" mode
>> for recvmmsg() makes sense though.
>
> I agree.  This is the mode I've seen people asking for.  They want the call
> to return as quickly as possible if there is data and then with as many
> messages as possible.  A MSG_WAITFORONE flag would do the trick nicely.

This patch might be woefully inadequate, as I'm not intimately
familiar with the rest of the Linux socket code, and I'm not sure what
the impact is of (a) adding that new flag, which is the first beyond
the 16-bit space, and (b) having that extra undefined flag present
during the underlying recvmsg() calls, but this patch Works For Me for
my isolated case.  Thoughts? (hoping gmail doesn't mangle this)

[blblack@xpc kernels]$ diff -u linux-2.6.33-orig/net/socket.c
linux-2.6.33/net/socket.c
--- linux-2.6.33-orig/net/socket.c	2010-02-24 12:52:17.000000000 -0600
+++ linux-2.6.33/net/socket.c	2010-03-24 18:10:37.156234986 -0500
@@ -2133,7 +2133,10 @@

 		if (err)
 			break;
-		++datagrams;
+
+                /* MSG_WAITFORONE turns on MSG_DONTWAIT after one packet */
+		if (!datagrams++ && flags & MSG_WAITFORONE)
+			flags |= MSG_DONTWAIT;

 		if (timeout) {
 			ktime_get_ts(timeout);
[blblack@xpc kernels]$ diff -u
linux-2.6.33-orig/include/linux/socket.h
linux-2.6.33/include/linux/socket.h
--- linux-2.6.33-orig/include/linux/socket.h	2010-02-24 12:52:17.000000000 -0600
+++ linux-2.6.33/include/linux/socket.h	2010-03-24 17:35:14.009266280 -0500
@@ -255,6 +255,7 @@
 #define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
 #define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
 #define MSG_MORE	0x8000	/* Sender will send more */
+#define MSG_WAITFORONE  0x10000 /* recvmmsg(): block until 1+ packets avail */

 #define MSG_EOF         MSG_FIN
