Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2AXFgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 00:36:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33310 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2AXFgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 00:36:07 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzP4xEbcNmZ+MS0SQ3LrULzSq+dBiT_X9U-bPpR-Ukgrw@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
	<1327139539-14301-7-git-send-email-yinghai@kernel.org>
	<CA+55aFzP4xEbcNmZ+MS0SQ3LrULzSq+dBiT_X9U-bPpR-Ukgrw@mail.gmail.com>
Date: Mon, 23 Jan 2012 21:36:07 -0800
X-Google-Sender-Auth: luq7M0LCusDHUV8aVd_oKNUg86Y
Message-ID: <CAE9FiQVWtqinNYLRo34VNtUavYm6ifq_tp2f3Rr9+Pyc59DEnQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] pciehp: Add Disable/enable link functions
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 8:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jan 21, 2012 at 1:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> +
>> +       retval = pciehp_readw(ctrl, PCI_EXP_LNKCTL, &lnk_ctrl);
>> +       if (retval) {
>> +               ctrl_err(ctrl, "Cannot read LNKCTRL register\n");
>> +               return retval;
>> +       }
>
> Is there really any point at all in checking the return value of that
> readw() function?
>
> Nobody actually ever sets it. We should stop even bothering to pretend
> to care. There is no return value in real life.
>
> If the device doesn't exist or the read fails, you will never ever get
> an error *anyway*. You'll likely get 0xffff, and possibly a machine
> check exception. And that is unlikely to ever change - even if the
> hardware were to do it, it's insane to do error checking on an
> individual IO level. It causes more problems than it could possibly
> ever solve - error checking has to be done at a different level than
> on some random individual access.
>
> We should make the return type of pci_read_config_word() be 'void',
> instead of having code like this that looks like it is careful, but in
> actual fact in reality is just totally pointless.

looks like

#define PCI_OP_READ(size,type,len) \
int pci_bus_read_config_##size \
        (struct pci_bus *bus, unsigned int devfn, int pos, type *value) \
{                                                                       \
        int res;                                                        \
        unsigned long flags;                                            \
        u32 data = 0;                                                   \
        if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;       \
        raw_spin_lock_irqsave(&pci_lock, flags);                        \
        res = bus->ops->read(bus, devfn, pos, len, &data);              \
        *value = (type)data;                                            \
        raw_spin_unlock_irqrestore(&pci_lock, flags);           \
        return res;                                                     \
}

will check register number. like we can not pass 0x01 but want to read
word and dword.

also bus ops read/write like pci_mmcfg_read/write will double check if
passed bus/dev/fn/reg
ranges.

Thanks

Yinghai
