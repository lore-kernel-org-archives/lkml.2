Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0JZEPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 00:15:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0JZEPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 00:15:37 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=CAptr6ThvxoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_lCBdnZ5xphBHkuvcPoA:9 a=YETfBY0PkLMaXx5JsNE8xqJM7XUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Failed build on randconfig for DVB_DIB modules
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Oct 2010 00:15:36 -0400
Message-ID: <1288066536.18238.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently finishing up an automated test program (that I will be
publishing shortly). This program does various randconfig builds, boots
and tests (as well as bisecting and patch set testing). But enough about
it.

I hit this little build bug that is more annoying than anything else. If
I have the following configuration:


CONFIG_DVB_USB_DIBUSB_MB=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_NOVA_T_USB2=m

It fails to build with this error:

ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/dvb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/dvb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!

Those undefined functions are defined in
drivers/media/dvb/dvb-usb/dibusb-common.c, but are surrounded by:

#if defined(CONFIG_DVB_DIB3000MC) || 					\
	(defined(CONFIG_DVB_DIB3000MC_MODULE) && defined(MODULE))

Which Mauro updated in Dec 2007 with this commit:
4a56087f3b7660c9824e9ec69b96ccf8d9b25d1c
due to just having CONFIG_DVB_DIB3000MC not enough.

Well, this is not enough either. Why?

On build the object dibusb-common.o is built first because of the
DVB_USB_DIBUSB_MB being builtin kernel core. Thus, it gets built with
the preprocessor condition false.

Then when the compile gets to the modules, the object dibusb-common.o
has already been built, and gets linked in as is.

We end up with the functions not defined and we get the above error.

My question: Why does that preprocessor condition exist? Can't we just
build those functions in regardless?

-- Steve


