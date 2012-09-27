Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2I0OIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:08:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46322 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2I0OI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:08:29 -0400
Date: Thu, 27 Sep 2012 15:13:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@linux.intel.com,
        rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor
 out common code
Message-ID: <20120927151314.118c86c1@pyramind.ukuu.org.uk>
In-Reply-To: <20120927134110.GD6799@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
	<1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
	<20120925192048.GA17038@sirena.org.uk>
	<20120926145615.GJ10147@mail.gnudd.com>
	<20120926150429.GQ4428@opensource.wolfsonmicro.com>
	<20120926163145.GK10147@mail.gnudd.com>
	<20120926164932.GS4428@opensource.wolfsonmicro.com>
	<20120927134110.GD6799@mail.gnudd.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> as far as I know, nested locks are fine provided that you always take them in
> the same order and release them in the opposite order (lock A, lock B,
> unlock B, unlock A). So my conclusion is that nested spinlocks require
> potential regmap users of sta2x11 registers to take the sta2x11-mfd spinlock
> first. The pattern would be (sctl registers for instance):

The release order does not matter. Taking AB and releasing AB or BA is
fine. Taking AB and dropping B and retaking B is fine. Taking AB and
somewhere else taking BA is not. There are performance reasons in some
cases why taking AB releasing A is best with locks, but thats generally
with sleepable locks.

It's a bit more subtle because you often have other interactions. In
particular people often come unstuck on del_timer_sync or waiting for
workqueues and IRQs to finish (even in free_irq) while holding a lock
that the handler needs to take.

Alan
