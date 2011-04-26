Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab1DZSEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:04:46 -0400
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:20319 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755168Ab1DZSEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:04:45 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915 completely unusable in 2.6.38.x
Date: Tue, 26 Apr 2011 20:04:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
References: <4DB53B79.4070704@kernelpanic.ru> <20110425210323.GA23418@kroah.com> <201104260959.53084@rk-nord.at>
In-Reply-To: <201104260959.53084@rk-nord.at>
Cc: Greg KH <greg@kroah.com>, dri-devel@lists.freedesktop.org
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104262004.42776@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Melchior FRANZ -- Tuesday 26 April 2011:
> [https://bugzilla.kernel.org/show_bug.cgi?id=31522]

I've replied to this error message, but here again for this audience:
The commit that broke all 2.6.38.* releases for my machine is this:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ba3820ade317ee36e496b9b40d2ec3987dd4aef0
(Takashi Iwai: "drm/i915: Revive combination mode for backlight
control").

In 'is_backlight_combination_mode()' INTEL_INFO(dev)->gen
equals 4, and the function returns 0x40000000 in "combination mode".
In 'intel_panel_get_backlight()' this happens:


  val = I915_READ(BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK; // val = 0x0b4a
  if (IS_PINEVIEW(dev))                                     // false
          val >>= 1;

  if (is_backlight_combination_mode(dev)){
          u8 lbpc;

          val &= ~1;                                        // val = 0x0b4a
          pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc); // lbpc = 0
          val *= lbpc;                                      // val = 0
  }


The backlight remains off and does also not react to the "brighter" key
event.

Reverting the patch fixes my system, obviously.

m.
