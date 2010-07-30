Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0G3IBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:01:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab0G3IBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:01:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: stepanm@codeaurora.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Fri, 30 Jul 2010 10:01:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp> <20100729090607.GN26098@amd.com> <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
In-Reply-To: <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201007301001.02509.arnd@arndb.de>
X-Provags-ID: V02:K0:yqKg7edGhUadRutzMwDl4r0S8lTlPHmYkt4c7TpL4Uk
 jHrhQ7YpOgF+J24YG2a8leU9xv7ZU8g9qtac/JAzxCYqb4kGIe
 YYVHVpkONVQ3J24GEh2x9sGqig3mVwT7Zyn5Am+2wQVJGtxTqU
 sXMr6hj9iTwc8cMqJPsM2WUiUsLZwb+G5wpP7IQHjzzIwuo6cT
 ZJAzw2vwGOIgf1scmpoyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 July 2010 07:19:06 stepanm@codeaurora.org wrote:
> Unlike a more traditional system with one IOMMU between the bus and
> memory, MSM has multiple IOMMUs, with each one hard-wired to a dedicated
> device. Furthermore, each IOMMU can have more than one translation
> context. One of the use cases is being able to create mappings within
> multiple instances of one context, and arbitrarily context-switch the
> IOMMU on the fly.
> 
> It sounds like the domain abstraction and attach_device/detach_device can
> encapsulate this rather nicely and I am in the process of updating my
> driver to fit this framework.
> 
> My problem, however, is with iommu_domain_alloc(). This will set up a
> domain and call the ops function to initialize it, but I want to be able
> to pass it an “IOMMU id" that will tell the underlying driver which IOMMU
> (and which "stream id") is to be associated with that domain instance.

This probably best fits into the device itself, so you can assign the
iommu data when probing the bus, e.g. (I don't know what bus you use)

struct msm_device {
	struct msm_iommu *iommu;
	struct device dev;
};

This will work both for device drivers using the DMA API and for KVM
with the IOMMU API.

> This can be a void* parameter that gets passed through to domain_init. I
> feel like this change will make it easy to deal with multiple
> IOMMUs/translation contexts, and implementations that have only a singular
> IOMMU/translation context are free to ignore that parameter.
> 
> The alternative for me is to have a separate msm_iommu_domain_alloc(void
> *context_id) function, to which I can specify which IOMMU I want to use,
> but I would like to fully use your API if possible.

No, that would require adding msm specific code to KVM and potential
other users.

	Arnd
