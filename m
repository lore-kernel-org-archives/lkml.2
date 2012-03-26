Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab2CZPZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:25:06 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:56075 "HELO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932303Ab2CZPZD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:25:03 -0400
From: Yevgeny Petrilin <yevgenyp@mellanox.com>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yael Shenhav <yaeli@mellanox.com>
Subject: RE: IRQ affinity enforced only after first interrupt.
Thread-Topic: IRQ affinity enforced only after first interrupt.
Thread-Index: AQHNC1y2rxLl684DNUalJftF5VRURpZ8gpKAgAAuH0A=
Date: Mon, 26 Mar 2012 15:24:57 +0000
Message-ID: <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com>
References: <4F7031A4.70601@mellanox.co.il>
 <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com>
 <4F707E39.50502@gmail.com>
In-Reply-To: <4F707E39.50502@gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.13.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The architecture specific code will determine whether the IRQ could be migrated
> in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
> systems if interrupt remapping is enabled.

Actually I am encountering this issue with x86, and see different behavior with different
HW devices (NICs). On same machine I have one device that responds immediately to affinity changes
while the other one changes the affinity only after first interrupt.

> 
> On 03/26/2012 10:28 PM, Bjorn Helgaas wrote:
> > [This is not really a PCI question, so +cc Thomas, LKML.]
> >
> > On Mon, Mar 26, 2012 at 3:06 AM, Yevgeny Petrilin
> > <yevgenyp@mellanox.co.il> wrote:
> >> Hello,
> >>
> >> I'm working on an issue where affinity changes to IRQ only have effect after the first interrupt which still happens on the original core.
> >> I understand that the decision regarding it takes place in this code:
> >>
> >>        if (irq_can_move_pcntxt(data)) {
> >>                ret = chip->irq_set_affinity(data, mask, false);
> >>                switch (ret) {
> >>                case IRQ_SET_MASK_OK:
> >>                        cpumask_copy(data->affinity, mask);
> >>                case IRQ_SET_MASK_OK_NOCOPY:
> >>                        irq_set_thread_affinity(desc);
> >>                        ret = 0;
> >>                }
> >>        } else {
> >>                irqd_set_move_pending(data);
> >>                irq_copy_pending(desc, mask);
> >>        }
> >>
> >> Which means that the "IRQD_MOVE_PCNTXT" flag is not set in irq_data->state_use_accessors.
> >> I was able to add this flag using irq_modify_status(), which is probably not the way to go.
> >> This option also doesn't exist in older kernels (2.6.32)
> >>
> >> So the question is, when irq_desc is created, how is it determined that "IRQD_MOVE_PCNTXT" flag is set?
> >>
> >> Thanks,
> >> Yevgeny

