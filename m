Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1KWXCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:02:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60763 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab1KWXCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:02:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111123144417.2da5958c@jbarnes-desktop>
References: <20111123144417.2da5958c@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Nov 2011 15:02:01 -0800
X-Google-Sender-Auth: ozZwHFpd_lLTWBJZt60CWeF7l0w
Message-ID: <CA+55aFyaiJBYmgVCLfPA7q3hqtPHYh9wwsmVTCewbBoxMsDE8A@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 2:44 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Nothing too exciting this time, mostly some minor fixes for things
> normal people don't really hit.  Happy Thanksgiving.

Ugh. This looks bogus:

> Kenji Kaneshige (2):
>      PCI: pciehp: wait 1000 ms before Link Training check

Look at that patch more closely. After the patch, the code looks like this:


         if (ctrl->link_active_reporting)
                 pcie_wait_link_active(ctrl);
         else
                 msleep(1000);

+	/*
+	 * Need to wait for 1000 ms after Data Link Layer Link Active
+	 * (DLLLA) bit reads 1b before sending configuration request.
+	 * We need it before checking Link Training (LT) bit becuase
+	 * LT is still set even after DLLLA bit is set on some platform.
+	 */
+	msleep(1000);

and I'm pretty sure you should remove the "else msleep(1000)" there.
Doing the 1s wait *twice* seems entirely bogus, even if you are
missing link_active_reporting. No?

I pulled it since I can't test it, but it really smells fishy to me.

                  Linus
