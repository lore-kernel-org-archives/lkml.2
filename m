Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0KINEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:04:44 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:38877 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0KINEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:04:43 -0500
Date: Tue, 9 Nov 2010 22:04:25 +0900
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: gpiolib: Questions about gpiochip_find_base()
Message-ID: <20101109130425.GE15927@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a few questions about gpiochip_find_base() which I hope someone can
help with.

* At the end of gpiochip_add() there is the following code:

	if (gpio_is_valid(base))
		pr_debug("%s: found new base at %d\n", __func__, base);
	return base;

  It is unclear to me why !gpio_is_valid(base) isn't an error condition
  given that the following appears in gpiochip_add(), the caller of
  gpiochip_find_base(), in the case where base isn't to be dynamic
  selected.

	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
			&& base >= 0) {
		status = -EINVAL;
		goto fail;
	}

* In the same vein, its unclear to me why
  the loop in gpiochip_find_base() checks values of i
  that may not be valid according to gpio_is_valid().

  Specifically I am wondering why

	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
		...
		if (!chip && !test_bit(FLAG_RESERVED, &desc->flags)) {
			...

  isn't something like


	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
		...
		if (gpio_is_valid(i) && !chip &&
		    !test_bit(FLAG_RESERVED, &desc->flags)) {
			...

* I am wondering if in gpiochip_add() the following is unnecessary
  in the case where base is dynamic as gpiochip_add() seems to
  ensure that gpio_desc[id].chip is NULL for the dynamically selected range.

	for (id = base; id < base + chip->ngpio; id++) {
		if (gpio_desc[id].chip != NULL) {
			status = -EBUSY;
			break;
		}
	}
