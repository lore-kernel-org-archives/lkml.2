Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0D1MHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:07:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab0D1MHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:07:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
Date: Wed, 28 Apr 2010 14:06:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1272429513.24542.83.camel@pasglop>
In-Reply-To: <1272429513.24542.83.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004281406.04080.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX195YEBNF//qCw1MxRdr9qNGq+MSckJj4iUolpS
 pEUbZb5AWj1h0Am2lzz6yp4TP/w3Ek5HjtZiEpdm/m+vBbKjQd
 UUgAvoGS1lHXn2PlqtQ7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Benjamin Herrenschmidt wrote:
> Now, we -could- make it a bit smarter about the BKL by introducing a
> contention counter and only go out if we own the BKL and it is contended,
> but I didn't feel like this was worth the effort, time is better spent
> removing the BKL from sensitive code path instead.

Agreed.

> -       for (;;) {
> +       for (timeout = jiffies + 2; jiffies < timeout;) {
> [...]
> -       for (;;) {
> +       while (jiffies < timeout) {

This needs to use time_before() to avoid problems on jiffies wraparound.

	Arnd
