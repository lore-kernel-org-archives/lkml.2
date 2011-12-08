Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1LHV1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:27:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58464 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1LHV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:27:04 -0500
MIME-Version: 1.0
In-Reply-To: <4EE0B156.4080708@ladisch.de>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
	<CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
	<4EDBA70E.3090905@ladisch.de>
	<CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
	<CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
	<4EE0B156.4080708@ladisch.de>
Date: Thu, 8 Dec 2011 22:27:03 +0100
Message-ID: <CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for explaining the PCI to PCIe bridge architecture. Of course,
the ASM1083 can only be the cause if the Firewire controller is also
on that bus. Which I don't know.

> It appears that some Deassert_INTx messages get lost on your system.
> There are no indications of any other missing PCIe packets, so this
> looks like a problem with the interrupt handling in your PCI/PCIe
> bridge, the ASM1083 chip.

Assuming this is the case, I modified the e1000 driver to explicitly
set its IRQ line after 5 times having to send IRQ_NONE. (e1000_intr()
code at end of this post). The result of this test is that the IRQ
line indeed is set (in the next invocation, the ISR sees the forced
RXT0 interrupt, clears the IRQ line and sends IRQ_HANDLED). But alas,
the storm is not silenced at all.

If the ASM108x was the problem, I suspect that explicitly raising and
clearing the interrupt would have retriggered the INTx_Assert and
INTx_Deassert messages ? Meaning the bridge wouldn't be the problem.

@ Clemens: If I understand correctly, the IO-APIC is not even used in
this case ? (IRQ requests from e1000 all going through PCIe) Or is
there also a virtual IO-APIC monitoring Assert and Deassert messages.
Is the BIOS responsible for writing a mapping for the PCI IRQs to MSIs
into the ASM108x ? (And BTW, should the linux1394-devel still be
posted ?)

I'm thinking of immediately re-enabling the irqs after they've been
disabled in spurious.c.

I also think that the following posts may refer to the same problem:

http://ubuntuforums.org/showthread.php?t=1883854
https://lkml.org/lkml/2011/6/30/197
https://lkml.org/lkml/2011/10/14/146

Rgds,


J.


dmesg log:

[247181.656647] e1000: ours (60)
[247183.660996] e1000: ours (61)
[247185.664907] e1000: ours (62)
[247185.664926] e1000: not ours (0)
[247185.664937] e1000: not ours (1)
[247185.664948] e1000: not ours (2)
[247185.664958] e1000: not ours (3)
[247185.664968] e1000: not ours (4)
[247185.664982] e1000: sending RXT0 interrupt (mask=0x00000000)
[247185.664997] e1000: ours (63)
[247185.665009] e1000: not ours (0)
[247185.665024] e1000: not ours (1)
[247185.665034] e1000: not ours (2)
[247185.665041] e1000: not ours (3)
[247185.665053] e1000: not ours (4)
[247185.665065] e1000: sending RXT0 interrupt (mask=0x0000009d)
[247185.665077] e1000: ours (64)
[247185.665085] e1000: not ours (0)
[247185.665095] e1000: not ours (1)
[247185.665105] e1000: not ours (2)
[247186.319878] irq 19: nobody cared (try booting with the "irqpoll" option)
[247186.319887] Pid: 0, comm: swapper Not tainted 3.2.0-rc2 #2
[247186.319891] Call Trace:
[247186.319894]  <IRQ>  [<ffffffff810bbafd>] __report_bad_irq+0x3d/0xe0
[247186.319912]  [<ffffffff810bbf3d>] note_interrupt+0x14d/0x210
[247186.319918]  [<ffffffff810b98c4>] handle_irq_event_percpu+0xc4/0x290
[247186.319924]  [<ffffffff810b9ad8>] handle_irq_event+0x48/0x70
[247186.319930]  [<ffffffff810bc92a>] handle_fasteoi_irq+0x5a/0xe0
[247186.319937]  [<ffffffff81004012>] handle_irq+0x22/0x40
[247186.319943]  [<ffffffff81506caa>] do_IRQ+0x5a/0xd0
[247186.319950]  [<ffffffff814fe86b>] common_interrupt+0x6b/0x6b
[247186.319953]  <EOI>  [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
[247186.319970]  [<ffffffffa00c50d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[247186.319978]  [<ffffffffa00c50ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[247186.319986]  [<ffffffff814224e8>] cpuidle_idle_call+0xb8/0x230
[247186.319992]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[247186.319999]  [<ffffffff814e24a0>] rest_init+0x94/0xa4
[247186.320006]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[247186.320013]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[247186.320018]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[247186.320022] handlers:
[247186.320030] [<ffffffffa008e4f0>] e1000_intr
[247186.320034] Disabling IRQ #19


The modified e1000 interrupt handler:

static irqreturn_t e1000_intr(int irq, void *data)
{
        struct net_device *netdev = data;
        struct e1000_adapter *adapter = netdev_priv(netdev);
        struct e1000_hw *hw = &adapter->hw;
        u32 icr = er32(ICR);

        static int i_not_ours = 0;

        if (unlikely((!icr))) {
                if (i_not_ours < 5) {
                        if (printk_ratelimit())
                                printk("e1000: not ours (%d)\n", i_not_ours++);
                }
                else {
                        if (printk_ratelimit())
                                printk("e1000: sending RXT0 interrupt
(mask=0x%08x)\n", er32(IMS));
                        ew32(ICS, E1000_ICS_RXT0);
                }
                return IRQ_NONE;  /* Not our interrupt */
        }

        /*
         * we might have caused the interrupt, but the above
         * read cleared it, and just in case the driver is
         * down there is nothing to do so return handled
         */
        if (unlikely(test_bit(__E1000_DOWN, &adapter->flags))) {
                static int i = 0;
                if (printk_ratelimit())
                        printk("e1000: ours, but down (%d)\n", i++);
                return IRQ_HANDLED;
        }

        if (unlikely(icr & (E1000_ICR_RXSEQ | E1000_ICR_LSC))) {
                hw->get_link_status = 1;
                /* guard against interrupt when we're going down */
                if (!test_bit(__E1000_DOWN, &adapter->flags))
                        schedule_delayed_work(&adapter->watchdog_task, 1);
        }

        /* disable interrupts, without the synchronize_irq bit */
        ew32(IMC, ~0);
        E1000_WRITE_FLUSH();

        if (likely(napi_schedule_prep(&adapter->napi))) {
                adapter->total_tx_bytes = 0;
                adapter->total_tx_packets = 0;
                adapter->total_rx_bytes = 0;
                adapter->total_rx_packets = 0;
                __napi_schedule(&adapter->napi);
        } else {
                /* this really should not happen! if it does it is basically a
                 * bug, but not a hard error, so enable ints and continue */
                if (!test_bit(__E1000_DOWN, &adapter->flags))
                        e1000_irq_enable(adapter);
        }

        {
                static int i = 0;
                if (printk_ratelimit())
                        printk("e1000: ours (%d)\n", i++);
                i_not_ours = 0;
        }

        return IRQ_HANDLED;
}
