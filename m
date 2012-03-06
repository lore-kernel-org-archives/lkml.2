Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab2CFJdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:33:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2CFJdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:33:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Shi <alex.shi@intel.com>
Subject: Re: [RFC patch] spindep: add cross cache lines checking
Date: Tue, 6 Mar 2012 09:32:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
References: <1330917630.18835.44.camel@debian> <20120305104311.GA18556@elte.hu> <1331014414.18835.254.camel@debian>
In-Reply-To: <1331014414.18835.254.camel@debian>
MIME-Version: 1.0
Message-Id: <201203060932.45223.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:nkuWY/ep7WXXBMb1hLemXrAOXg3tpQu0xtGROjf1cAl
 fZjZUx/83/2itREV7BLQba/li2neqQFVXk6Ae0z+H2Cbptb8gx
 Eh79KSavq7sU1Fvg6IOdk7U2Ey3nzZUuIOYhYs+pyiriDV+/+7
 MjAQg5iPNCDB++jLXETlw4NFaTXlG5yeLtndRQALA8V2aIAorZ
 X/uWisC9el/cfLU6Qp4iTQQrerhKaCHdYqfo1qvAt6UjBPvvtj
 emKVAh0rLsnKMZ4BrRjUC0rlyxTg+ADDvjoGng7ypfnAvmNWa3
 O/lNonGnkksi9RViWCOWwQYHFqi53JpajbMk0apyZueg7MmKhr
 SPI+89NVSM77BQxICSMY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012, Alex Shi wrote:
> I have one concern and one questions here:
> concern: maybe the lock is in a well designed 'packed' struct, and it is
> safe for cross lines issue. but __alignof__ will return 1;
> 
> struct abc{
>         raw_spinlock_t lock1;
>         char            a;
>         char            b;
> }__attribute__((packed));
> 
> Since the lock is the first object of struct, usually it is well placed.

No, it's actually not. The structure has an external alignment of 1, so
if you have an array of these or put it into another struct like

struct xyz {
	char x;
	struct abc a;
};

then it will be misaligned. Thre is no such thing as a well designed 'packed'
struct. The only reason to use packing is to describe structures we have no
control over such as hardware layouts and on-wire formats that have unusal
alignments, and those will never have a spinlock on them.

	Arnd
