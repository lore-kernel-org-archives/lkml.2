Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0C0Jyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 05:54:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58990 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0C0Jyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 05:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LJnsuBn36qW/z+u+gU8PdkLqLREDv13Cmfld1LzMKSy3Muy0XlXSVD4BKf78CAlNQ6
         iaOhNhcEksV3hkow6AKKVdRINGaEfRgNuVSnIVm0oO/enX3us8DDQCSWPy7ciCDFtjnJ
         cFEv+dTAtsesY1U141IhqoWyLxCQzYSM5VWhk=
MIME-Version: 1.0
In-Reply-To: <87634oid4y.fsf@pollan.anholt.net>
References: <ho2jal$oqs$1@dough.gmane.org> <87wrx5m1h3.fsf@pollan.anholt.net>
	 <bad735c81003220111y44bfb828vfd4c9fbbcabf3419@mail.gmail.com>
	 <87634oid4y.fsf@pollan.anholt.net>
Date: Sat, 27 Mar 2010 10:54:36 +0100
Message-ID: <bad735c81003270254i5e1cdb3dv26c1566e5d005e9f@mail.gmail.com>
Subject: Re: i915 lockup / extreme delay
From: Karl Vogel <karl.vogel@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2R9sqmE024290

On Mon, Mar 22, 2010 at 4:34 PM, Eric Anholt <eric@anholt.net> wrote:> On Mon, 22 Mar 2010 09:11:06 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:>> On Mon, Mar 22, 2010 at 5:20 AM, Eric Anholt <eric@anholt.net> wrote:>> > On Sat, 20 Mar 2010 14:41:41 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:>> >> The 'effect' is that only the mouse pointer works in the X server. The>> >> cpu usage on the laptop during the sluggishness is minimal. When I>> >> suspend the game with winedbg, the X server slowly becomes responsive again.>> >>>> >> The output from latencytop seems to point to i915 being the culprit:>> >>> > If there's some code doing glFlush()es, it's probably that code at>> > fault. †You don't need to do that unless you're doing frontbuffer>> > rendering, and if you're doing frontbuffer rendering you should really>> > be doing backbuffer rendering. †I don't see a kernel issue here.>>>> That doesnt explain why the box completely locks up on 2.6.34-rc2>> though, where only a cold reboot works.>> Missed that part of the message. †If there's a regression, bisect> please.
Apparently the crash was caused by a hardware bug in the intel chipsetwhich is 8086:2a40 rev 07. While doing the bisect I got an error:
DRHD: handling fault status reg 2DMAR:[DMA Write] Request device [00:02.0] fault addr dd69a000DMAR:[fault reason 05] PTE Write access is not set
After some googling around, I found this bugzilla entry which explains it:
https://bugzilla.redhat.com/show_bug.cgi?id=538163#c58
The issue appears that the graphics chip is corrupting memory:
"Unfortunately, this particular chipset sometimes reads from the GTT, does thetranslation, then writes the translated address back to the _original_ GTTinstead of to the shadow GTT. That's why you're seeing real physical addresseswhere you should have 'virtual DMA addresses', and you get the faults. † "
Adding "intel_iommu=igfx_off" to the kernel command line resolved the issue.The fedora kernel automatically disables this when it detects this particularchipset revision.
As for the freeze/slowdown right after booting, sysprof shows that more than 77%of the time is spent inside: drm_mode_getconnector
[/usr/bin/Xorg] † † † † † † † † † † † † † † † † † † † † † † † † † 0.00% †80.29%†ioctl † † † † † † † † † † † † † † † † † † † † † † † † † † † † † 0.00% †78.47%† †- - kernel - - † † † † † † † † † † † † † † † † † † † † † † † †0.01% †78.47%† † †system_call_fastpath † † † † † † † † † † † † † † † † † † † †0.00% †77.15%† † † †sys_ioctl † † † † † † † † † † † † † † † † † † † † † † † † 0.00% †77.15%† † † † †do_vfs_ioctl † † † † † † † † † † † † † † † † † † † † † †0.01% †77.15%† † † † † †vfs_ioctl † † † † † † † † † † † † † † † † † † † † † † 0.00% †77.14%† † † † † † †drm_ioctl † † † † † † † † † † † † † † † † † † † † † 0.01% †77.14%† † † † † † † †drm_mode_getconnector † † † † † † † † † † † † † † 0.00% †77.02%† † † † † † † † †drm_helper_probe_single_connector_modes † † † † 0.00% †77.02%† † † † † † † † † †intel_lvds_get_modes † † † † † † † † † † † † †0.00% †62.46%† † † † † † † † † † †intel_ddc_get_modes † † † † † † † † † † † † 0.00% †62.46%† † † † † † † † † † † †drm_get_edid † † † † † † † † † † † † † † †0.00% †62.45%† † † † † † † † † † † † †drm_ddc_read_edid † † † † † † † † † † † 0.00% †62.45%† † † † † † † † † † † † † †drm_do_probe_ddc_edid † † † † † † † † 0.00% †62.45%† † † † † † † † † † † † † † †i2c_transfer † † † † † † † † † † † †0.00% †62.45%† † † † † † † † † † † † † † † †bit_xfer † † † † † † † † † † † † †0.01% †62.44%† † † † † † † † † † † † † † † † †sclhi † † † † † † † † † † † † † 0.00% †25.76%† † † † † † † † † † † † † † † † † †set_clock † † † † † † † † † † 0.08% †12.86%† † † † † † † † † † † † † † † † † †__udelay † † † † † † † † † † †0.00% †12.78%† † † † † † † † † † † † † † † † † †get_clock † † † † † † † † † † 0.11% † 0.11%† † † † † † † † † † † † † † † † † †__const_udelay † † † † † † † †0.01% † 0.01%† † † † † † † † † † † † † † † † †set_clock † † † † † † † † † † † 0.12% †12.54%† † † † † † † † † † † † † † † † † †__const_udelay † † † † † † † †0.01% †12.42%† † † † † † † † † † † † † † † † † †__delay † † † † † † † † † † † 0.00% † 0.00%† † † † † † † † † † † † † † † † †__udelay † † † † † † † † † † † †0.00% †12.08%† † † † † † † † † † † † † † † † †acknak † † † † † † † † † † † † †0.00% † 7.68%† † † † † † † † † † † † † † † † †sdahi † † † † † † † † † † † † † 0.01% † 2.30%† † † † † † † † † † † † † † † † †try_address † † † † † † † † † † 0.00% † 1.20%† † † † † † † † † † † † † † † † †i2c_outb † † † † † † † † † † † †0.00% † 0.59%† † † † † † † † † † † † † † † † †get_data † † † † † † † † † † † †0.11% † 0.11%† † † † † † † † † † † † † † † † †i2c_stop † † † † † † † † † † † †0.00% † 0.09%† † † † † † † † † † † † † † † † †i2c_repstart † † † † † † † † † †0.00% † 0.07%† † † † † † † † † † † † † † † † †i2c_start † † † † † † † † † † † 0.00% † 0.01%† † † † † † † † † † † † † † † † †__const_udelay † † † † † † † † †0.01% † 0.01%† † † † † † † † † † † † † † † †__udelay † † † † † † † † † † † † †0.01% † 0.01%† † † † † † † † † † † †drm_add_edid_modes † † † † † † † † † † † †0.00% † 0.00%† † † † † † † † † † † †drm_mode_connector_update_edid_property † 0.00% † 0.00%† † † † † † † † † †intel_hdmi_detect † † † † † † † † † † † † † † 0.00% † 8.01%† † † † † † † † † †intel_dp_detect † † † † † † † † † † † † † † † 0.00% † 4.91%† † † † † † † † † †intel_tv_detect † † † † † † † † † † † † † † † 0.00% † 1.23%† † † † † † † † † †intel_lvds_detect † † † † † † † † † † † † † † 0.00% † 0.38%† † † † † † † † † †intel_crt_detect † † † † † † † † † † † † † † †0.00% † 0.03%† † † † † † † † † †drm_get_connector_name † † † † † † † † † † † †0.00% † 0.01%† † † † † † † †i915_gem_execbuffer † † † † † † † † † † † † † † † 0.00% † 0.06%† † † † † † † †i915_gem_mmap_ioctl † † † † † † † † † † † † † † † 0.00% † 0.01%† † † † † † † †i915_gem_set_domain_ioctl † † † † † † † † † † † † 0.00% † 0.01%† † † † † † † †drm_gem_close_ioctl † † † † † † † † † † † † † † † 0.00% † 0.01%† † † † † † † †drm_mode_object_find † † † † † † † † † † † † † † †0.00% † 0.00%† † † † † † † †i915_gem_busy_ioctl † † † † † † † † † † † † † † † 0.00% † 0.00%† † † † † † † †lock_kernel † † † † † † † † † † † † † † † † † † † 0.00% † 0.00%† † † † † † † †i915_gem_create_ioctl † † † † † † † † † † † † † † 0.00% † 0.00%† † † † † † † †copy_to_user † † † † † † † † † † † † † † † † † † †0.00% † 0.00%† † † † † † †copy_user_generic_string † † † † † † † † † † † † † †0.00% † 0.00%ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
