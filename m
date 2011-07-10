Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1GJRMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 13:12:05 -0400
Received: from mail.perches.com ([173.55.12.10]:3791 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab1GJRMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 13:12:00 -0400
Subject: state machine defect in drivers/tty/vt/vt.c?
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 10:11:59 -0700
Message-ID: <1310317919.3848.38.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vc->vc_state is sequentially set to different values.

Looks like there's either a return or a break
missing at the end of case ESgetpars:

Anyone know the right fix here?

/* console_lock is held */
static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
{
[...]
	switch(vc->vc_state) {
[...]
	case ESgetpars:
		if (c == ';' && vc->vc_npar < NPAR - 1) {
			vc->vc_npar++;
			return;
		} else if (c>='0' && c<='9') {
			vc->vc_par[vc->vc_npar] *= 10;
			vc->vc_par[vc->vc_npar] += c - '0';
			return;
		} else
			vc->vc_state = ESgotpars;
	case ESgotpars:
		vc->vc_state = ESnormal;



