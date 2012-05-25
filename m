Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2EYKKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:10:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36137 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2EYKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:10:51 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <herbert@gondor.hengli.com.au>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <GPontis@z9.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] hw_random: atmel-rng: fix race condition leading to repeated bits
References: <1337937158-9710-1-git-send-email-jacmet@sunsite.dk>
	<4FBF5916.4070705@atmel.com>
Date: Fri, 25 May 2012 12:10:47 +0200
In-Reply-To: <4FBF5916.4070705@atmel.com> (Nicolas Ferre's message of "Fri, 25
	May 2012 12:04:06 +0200")
Message-ID: <877gw0a7vc.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nicolas" == Nicolas Ferre <nicolas.ferre@atmel.com> writes:

Hi,

 Nicolas> What about a single read to ISR like this:

 Nicolas> tmp = readl(trng->base + TRNG_ODATA);
 Nicolas> if (readl(trng->base + TRNG_ISR) & 1) {
 Nicolas> 	*data = tmp;
 Nicolas> 	return 4;
 Nicolas> } else {
 Nicolas>   	return 0;
 Nicolas> }

No, that won't work as you then have another race. Data might not be
ready when you read ODATA, but then become ready just in time for when
you read ISR, so you end up using stale data.

It all would have been easier if the ready bit would get cleared on
reads from ODATA instead of/as well as from ISR, but that's
unfortunately not the case.

-- 
Bye, Peter Korsgaard
