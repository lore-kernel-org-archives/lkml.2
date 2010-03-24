Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0CXTHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:07:36 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:49408 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab0CXTHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MwE4c1J8YMEw/dHRKiswAMDo+Q9vFrjYiRWdKJzNSVOrJlpC1Xc4hvtj5N5e0j04s0
         +ZdPHeITOTuLj9vVnroTCFxdA1Rz+nHZjqFNOH06RfJyD9tZpYiqJqfHdW5sm4dl2RzH
         1ITDteGxSlJIySTXLK70X1dAiN6FSG3vfsTc0=
MIME-Version: 1.0
In-Reply-To: <20100324111436.fe5d2906.akpm@linux-foundation.org>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	 <20100319132723.118cc16a.akpm@linux-foundation.org>
	 <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	 <20100321135836.GA11661@zhen-devel.sh.intel.com>
	 <ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	 <20100322205704.ac4cd9ae.akpm@linux-foundation.org>
	 <alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
	 <ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
	 <20100324111436.fe5d2906.akpm@linux-foundation.org>
Date: Wed, 24 Mar 2010 20:07:32 +0100
Message-ID: <ca2dc2821003241207v721119d6m9a14a3cc98ab35a6@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 7:14 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 23 Mar 2010 12:40:05 +0100
> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>
>> On Tue, Mar 23, 2010 at 5:14 AM, Christian Kujau <lists@nerdbynature.de> wrote:
>> > On Mon, 22 Mar 2010 at 20:57, Andrew Morton wrote:
>> >> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >> > I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
>> >
>> > I believe this[0] is fc61901373987ad61851ed001fe971f3ee8d96a3 upstream:
>>
>> Indeed. Also in
>>
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=fc61901373987ad61851ed001fe971f3ee8d96a3
>
> Does reverting that patch from the current code fix the crash?
>

I will recheck tomorrow but I think that it does, if
intel_private.gtt_total_size is still 32768 in current code instead of
65536 (I think I tried the patch I sent in 2.6.34-rc1 too).

> --- a/drivers/char/agp/intel-agp.c~revert-1
> +++ a/drivers/char/agp/intel-agp.c
> @@ -207,7 +207,6 @@ static struct _intel_private {
>         * popup and for the GTT.
>         */
>        int gtt_entries;                        /* i830+ */
> -       int gtt_total_size;
>        union {
>                void __iomem *i9xx_flush_page;
>                void *i8xx_flush_page;
> @@ -1239,7 +1238,7 @@ static int intel_i915_configure(void)
>        readl(intel_private.registers+I810_PGETBL_CTL); /* PCI Posting. */
>
>        if (agp_bridge->driver->needs_scratch_page) {
> -               for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {
> +               for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
>                        writel(agp_bridge->scratch_page, intel_private.gtt+i);
>                }
>                readl(intel_private.gtt+i-1);   /* PCI Posting. */
> @@ -1394,8 +1393,6 @@ static int intel_i915_create_gatt_table(
>        if (!intel_private.gtt)
>                return -ENOMEM;
>
> -       intel_private.gtt_total_size = gtt_map_size / 4;
> -
>        temp &= 0xfff80000;
>
>        intel_private.registers = ioremap(temp, 128 * 4096);
> @@ -1485,8 +1482,6 @@ static int intel_i965_create_gatt_table(
>        if (!intel_private.gtt)
>                return -ENOMEM;
>
> -       intel_private.gtt_total_size = gtt_size / 4;
> -
>        intel_private.registers = ioremap(temp, 128 * 4096);
>        if (!intel_private.registers) {
>                iounmap(intel_private.gtt);
> _
>
>
