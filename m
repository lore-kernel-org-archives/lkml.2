Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0EaRXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:23:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0EaRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:23:13 -0400
Message-ID: <4C03F04D.4040200@redhat.com>
Date: Mon, 31 May 2010 19:22:21 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, herbert@gondor.hengli.com.au,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
References: <20100531160425.GA20344@basil.fritz.box>
In-Reply-To: <20100531160425.GA20344@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 06:04 PM, Andi Kleen wrote:
> DM-CRYPT: Scale to multiple CPUs
> 
> Currently dm-crypt does all encryption work per dmcrypt mapping in a
> single workqueue. This does not scale well when multiple CPUs
> are submitting IO at a high rate. The single CPU running the single
> thread cannot keep up with the encryption and encrypted IO performance
> tanks.

This is true only if encryption run on the CPU synchronously.

(Usually it is high speed SSD or dm-crypt above striped RAID where
underlying device throughput is higher than CPU encryption speed.)

I did a lot of experiments with similar design and abandoned it.
(If we go this way, there should be some parameter limiting
used # cpu threads for encryption, I had this configurable
through dm messages online + initial kernel module parameter.)

But I see two main problems:

1) How this scale together with asynchronous
crypto which run in parallel in crypto API layer (and have limited
resources)? (AES-NI for example)

2) Per volume threads and mempools were added to solve low memory
problems (exhausted mempools), isn't now possible deadlock here again?

(Like one CPU, many dm-crypt volumes - thread waiting for allocating
page from exhausted mempool, blocking another request (another volume)
in queue later which will free some pages after crypt processing.
This cannot happen with per volume threads. Or am I missing something here?)


Anyway, I still think that proper solution to this problem is run
parallel requests in cryptoAPI using async crypt interface,
IOW paralelize this on cryptoAPI layer which know best which resources
it can use for crypto work.

(Herbert - is something like per cpu crypto threads planned
for use in this case?)

Milan
