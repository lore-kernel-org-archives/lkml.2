Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1IUGo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:44:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:53928 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1IUGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:44:26 -0400
Date: Wed, 21 Sep 2011 09:44:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: re: mfd: Simulate active high IRQs with wm831x
Message-ID: <20110921064415.GC4999@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E7987C7.0102:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Smatch complains about d71820b8a8fbe9 "mfd: Simulate active high IRQs
with wm831x"

drivers/mfd/wm831x-irq.c +522 wm831x_irq_thread(67)
	error: buffer overflow 'wm831x->gpio_level' 16 <= 56

   518                  /* Simulate an edge triggered IRQ by polling the input
   519                   * status.  This is sucky but improves interoperability.
   520                   */
   521                  if (primary == WM831X_GP_INT &&
   522                      wm831x->gpio_level[i - WM831X_IRQ_GPIO_1]) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   523                          ret = wm831x_reg_read(wm831x, WM831X_GPIO_LEVEL);
   524                          while (ret & 1 << (i - WM831X_IRQ_GPIO_1)) {
   525                                  handle_nested_irq(wm831x->irq_base + i);
   526                                  ret = wm831x_reg_read(wm831x,
   527                                                        WM831X_GPIO_LEVEL);
   528                          }
   529                  }

We're inside a for loop over ARRAY_SIZE(wm831x_irqs) which has 58
elements (so "i" is 0-57) and we subtract WM831X_IRQ_GPIO_1 (1) which
gives us a max of 56.  The ->gpio_level[] array only has 16 elements
so we're reading beyond the end of the array.

In wm831x_irq_set_type() it only sets the first 11 elements of the
->gpio_level[] array.  Perhaps something similar is needed here.  I
don't know the code well enough to say.

regards,
dan carpenter
