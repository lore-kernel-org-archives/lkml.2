Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1AFIsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:48:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31192 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1AFIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:48:52 -0500
X-IronPort-AV: E=Sophos;i="4.60,282,1291611600"; 
   d="scan'208";a="129805860"
Subject: Re: [Xen-devel] Re: [patch] xenfb: fix xenfb suspend/resume race
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Joe Jin <joe.jin@oracle.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "gurudas.pai@oracle.com" <gurudas.pai@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "guru.anbalagane@oracle.com" <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1294300924.13733.42.camel@localhost.localdomain>
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com>
	 <20101230164051.GC24313@dumpdata.com>
	 <1294139733.3831.141.camel@zakaz.uk.xensource.com>
	 <4D256BC7.1080501@oracle.com>
	 <1294300924.13733.42.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 6 Jan 2011 08:47:53 +0000
Message-ID: <1294303673.3831.3562.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 08:02 +0000, Ian Campbell wrote:
> 
> > Check if irq is valid will fix this issue.
> 
> No, it papers over the issue, the code should never have been allowed
> to get this far if the connection to the backend is not yet fully
> resumed (i.e. when irq == -1). 

On the other hand changing a kernel crash into a WARN_ON has merit in
its own right, I just think it is a stretch to say the xenfb issue is
fixed by it! You'd need to also make the warning go away to be able to
say that.

> @@ -175,6 +175,10 @@ static struct irq_info *info_for_irq(unsigned irq)
>  
>  static unsigned int evtchn_from_irq(unsigned irq)
>  {
> +     if (unlikely(irq < 0 || irq >= nr_irqs)) {
> +             WARN_ON(1, "[%s]: Invalid irq(%d)!\n", __func__, irq);

Did this compile without warnings? That isn't the correct syntax for a
WARN_ON since it takes only a condition and not the additional message.

I think this can simplified as:
	if (WARN(irq < 0 || irq >= nr_irqs, "invalid irq %d!\n", irq))
             return 0;

I think WARN includes the file name and line number as well as a stack
trace so including the function name is unnecessary.

I'm not sure the condition used is totally valid for a modern kernel
with sparse IRQs (it probably needs to do a irq_to_desc lookup) but I
think we can defer that until events.c moves to the more dynamic scheme
this implies (I should resurrect those patches now that thiongs have
settled down after the dom0 merge).

Ian.

