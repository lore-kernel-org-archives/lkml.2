Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2DOKjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:39:49 -0400
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:28967 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752956Ab2DOKjr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:39:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 92191.21858.bm@omp1052.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cgDpBEJv8icyox6JlWY5XSRgFB11Yizl5bsurMEjILAiWj/OV3AmSp3eOxEl1+DX3k+MXr+rV9rmC/EP0yIL98daQYysmyk4+VsgQ1N5fgdz82cC3r/sZePk8iv1mGJ1C0nkZvDfdsokMLv9tA27XAqZqPYBPTdogCO7S8yxzWU=;
X-YMail-OSG: tDxITIkVM1moqJ_9Oyd4WYEFz_4_gaq498deGoZb3RfjF9R
 d4Kxo9xWUmfycdnsRKWzVYsKLqDYD54RA6eLJA4jq814XzfwLEPjNAQnsx2a
 IioiMrT9fhUm_32u_YcFm84o281O0w9EbKx1j2SbqtHKSQNyqQAYADN.VEbx
 Wq1TEilFZhccJafe.ltaR8J55OB.hufgdfpXZ_O2CY_Xk75_8JOzo7ns69zm
 R.oPJxBFJX_EV69id_8iD.aHKXr4WZvug9ZAMdeVRQIpRMFHGLMXPB9.8TN2
 cDZ8S3kQhnqzp53M3Tgp5KvSBdbPQaO5UMBZ5dt9Hl.q3Frj.JxRpr6BtIY4
 m75J0_zdks4WduJaGpDiWrsSvuLm2PD0ejUQjXxgchwfQ4D83glnq9S6NpJk
 2oi4jye4N7TPvwY0gzcKCo3.gQtokbhsywYKl2CaeSFJkq_Zq8gMqxr17GqZ
 pYQIXB1b7oi.9gZ0S3N_7qK8Y0H3KnnLTeSKIaE3QuJEF0w--
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204132219.23106.rjw@sisk.pl> <1334350068.79333.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204150011.53556.rjw@sisk.pl>
Message-ID: <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 03:39:45 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <201204150011.53556.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki:

>>  > Please change that dev_dbg() in pci_restore_state() into dev_info()
>>  > and see how many times it gets printed with the commit applied (not 
> reverted).
>> 
>> 
>>  I ran the dmesg through "uniq -c" and it looks like this:
>> 
>>        1 ACPI: Low-level resume complete
>>        1 PM: Restoring platform NVS memory
>>        1 Enabling non-boot CPUs ...
>>        1 Booting Node 0 Processor 1 APIC 0x1
>>        1 CPU1 is up
>>        1 ACPI: Waking up from system sleep state S3
>>       10 pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 
> 0x20005151, writing 0x5151)
> 
> Well, yeah.  So the commit you bisected it to is total and utter crap.
> Most importantly, it retries the writes for all of the dwords in the 
> device's
> config space _including_ the status register (which by definition need not be
> the same as the written value).
> 
> I wonder if the appended patch helps?

It does. It seems there is a change only in the devices that refuse to wake up;
somehow writing too many times to them affects the rest of the machine.
So, for this machine your patch fixes the problem of the touchpad not working.

The write is now attempted (at most) 11 times, as shown below. Probably not
a huge deal.

      1 ACPI: Waking up from system sleep state S3
     11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)
      1 pcieport 0000:00:02.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:04.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:05.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
     11 pcieport 0000:00:06.0: restoring config space at offset 0x1c (was 0x20002121, writing 0x2121)
      1 pcieport 0000:00:06.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 pcieport 0000:00:0a.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
      1 ahci 0000:00:11.0: restoring config space at offset 0x4 (was 0x2300003, writing 0x2300007)
      1 ohci_hcd 0000:00:12.0: restoring config space at offset 0x4 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:12.2: BAR 0: set to [mem 0xd2408500-0xd24085ff] (PCI address [0xd2408500-0xd24085ff])
      1 ehci_hcd 0000:00:12.2: restoring config space at offset 0x4 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:12.2: PME# disabled
      1 ohci_hcd 0000:00:13.0: restoring config space at offset 0x4 (was 0x2a00002, writing 0x2a00013)
      1 ehci_hcd 0000:00:13.2: BAR 0: set to [mem 0xd2408400-0xd24084ff] (PCI address [0xd2408400-0xd24084ff])
      1 ehci_hcd 0000:00:13.2: restoring config space at offset 0x4 (was 0x2b00000, writing 0x2b00013)
      1 ehci_hcd 0000:00:13.2: PME# disabled
      1 pata_atiixp 0000:00:14.1: restoring config space at offset 0x4 (was 0x2300011, writing 0x2300015)
      1 radeon 0000:01:00.0: restoring config space at offset 0x4 (was 0x100003, writing 0x20100407)
      1 pci 0000:09:00.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100003)
      1 firewire_ohci 0000:0a:00.0: Refused to change power state, currently in D3
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x34 (was 0xffffffff, writing 0x44)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x24 (was 0xffffffff, writing 0xd1100c00)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x20 (was 0xffffffff, writing 0xd1100c80)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x14 (was 0xffffffff, writing 0xd1100d00)
     11 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100000)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x8 (was 0xffffffff, writing 0xc001000)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 firewire_ohci 0000:0a:00.0: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2380197b)
      1 sdhci-pci 0000:0a:00.1: Refused to change power state, currently in D3
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100b00)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 sdhci-pci 0000:0a:00.1: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2382197b)
      1 pci 0000:0a:00.2: Refused to change power state, currently in D3
      1 pci 0000:0a:00.2: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 pci 0000:0a:00.2: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.2: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 pci 0000:0a:00.2: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.2: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 pci 0000:0a:00.2: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.2: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100a00)
      1 pci 0000:0a:00.2: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 pci 0000:0a:00.2: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8050100)
      1 pci 0000:0a:00.2: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100003)
      1 pci 0000:0a:00.2: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2381197b)
      1 jmb38x_ms 0000:0a:00.3: Refused to change power state, currently in D3
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100900)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 jmb38x_ms 0000:0a:00.3: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2383197b)
      1 pci 0000:0a:00.4: Refused to change power state, currently in D3
      1 pci 0000:0a:00.4: restoring config space at offset 0x3c (was 0xffffffff, writing 0x10a)
      1 pci 0000:0a:00.4: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.4: restoring config space at offset 0x34 (was 0xffffffff, writing 0xa4)
      1 pci 0000:0a:00.4: restoring config space at offset 0x30 (was 0xffffffff, writing 0x0)
      1 pci 0000:0a:00.4: restoring config space at offset 0x2c (was 0xffffffff, writing 0x3600103c)
      1 pci 0000:0a:00.4: restoring config space at offset 0x28 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x24 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x20 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x1c (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x18 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x14 (was 0xffffffff, writing 0x0)
     11 pci 0000:0a:00.4: restoring config space at offset 0x10 (was 0xffffffff, writing 0xd1100800)
      1 pci 0000:0a:00.4: restoring config space at offset 0xc (was 0xffffffff, writing 0x800000)
      1 pci 0000:0a:00.4: restoring config space at offset 0x8 (was 0xffffffff, writing 0x8800000)
      1 pci 0000:0a:00.4: restoring config space at offset 0x4 (was 0xffffffff, writing 0x100007)
      1 pci 0000:0a:00.4: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2384197b)
      1 PM: noirq resume of devices complete after 6539.864 msecs
      1 PM: early resume of devices complete after 0.159 msecs
      1 ohci_hcd 0000:00:12.0: enabling bus mastering
...


Thanks,

Mikko


> 
> Rafael
> 
> 
> ---
> drivers/pci/pci.c |   50 ++++++++++++++++++++++++++++++++------------------
> 1 file changed, 32 insertions(+), 18 deletions(-)
> 
> Index: linux/drivers/pci/pci.c
> ===================================================================
> --- linux.orig/drivers/pci/pci.c
> +++ linux/drivers/pci/pci.c
> @@ -967,16 +967,40 @@ pci_save_state(struct pci_dev *dev)
>     return 0;
> }
> 
> +static void pci_restore_config_space(struct pci_dev *pdev, int start, int end,
> +                     int retry)
> +{
> +    int index;
> +
> +    for (index = end; index >= start; index--) {
> +        u32 val, saved;
> +        int offset = 4 * index;
> +        int count = retry;
> +
> +        saved = pdev->saved_config_space[index];
> +        pci_read_config_dword(pdev, offset, &val);
> +        while (saved != val) {
> +            dev_dbg(&pdev->dev, "restoring config space at offset 
> "
> +                "%#x (was %#x, writing %#x)\n",
> +                offset, val, saved);
> +            pci_write_config_dword(pdev, offset, saved);
> +            if (count-- > 0) {
> +                pci_read_config_dword(pdev, offset, &val);
> +                if (saved != val)
> +                    msleep(10);
> +            } else {
> +                break;
> +            }
> +        }
> +    }
> +}
> +
> /** 
>   * pci_restore_state - Restore the saved state of a PCI device
>   * @dev: - PCI device that we're dealing with
>   */
> void pci_restore_state(struct pci_dev *dev)
> {
> -    int i;
> -    u32 val;
> -    int tries;
> -
>     if (!dev->state_saved)
>         return;
> 
> @@ -984,24 +1008,14 @@ void pci_restore_state(struct pci_dev *d
>     pci_restore_pcie_state(dev);
>     pci_restore_ats_state(dev);
> 
> +    pci_restore_config_space(dev, 10, 15, 0);
>     /*
>      * The Base Address register should be programmed before the command
>      * register(s)
>      */
> -    for (i = 15; i >= 0; i--) {
> -        pci_read_config_dword(dev, i * 4, &val);
> -        tries = 10;        
> -        while (tries && val != dev->saved_config_space[i]) {
> -            dev_dbg(&dev->dev, "restoring config "
> -                "space at offset %#x (was %#x, writing %#x)\n",
> -                i, val, (int)dev->saved_config_space[i]);
> -            pci_write_config_dword(dev,i * 4,
> -                dev->saved_config_space[i]);
> -            pci_read_config_dword(dev, i * 4, &val);
> -            mdelay(10);
> -            tries--;
> -        }
> -    }
> +    pci_restore_config_space(dev, 4, 9, 10);
> +    pci_restore_config_space(dev, 0, 3, 0);
> +
>     pci_restore_pcix_state(dev);
>     pci_restore_msi_state(dev);
>     pci_restore_iov_state(dev);
> 
