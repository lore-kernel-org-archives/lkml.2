Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2B1Upd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:45:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56300 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2B1Upb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:45:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXAwgtwbCV_=qJnrs=YPZksoEBkjnQB=JbR7fc+UyKdzw@mail.gmail.com>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
	<1330091162-8141-4-git-send-email-danny.kukawka@bisect.de>
	<CAMuHMdXAwgtwbCV_=qJnrs=YPZksoEBkjnQB=JbR7fc+UyKdzw@mail.gmail.com>
Date: Tue, 28 Feb 2012 21:45:30 +0100
X-Google-Sender-Auth: gka6VxW2bYnKI_h1FiReAGfl7FM
Message-ID: <CAMuHMdW0Oh7h8tv85ScgHB50vMaZSU7S3cPJRsChnRe2sNL_kA@mail.gmail.com>
Subject: Re: [PATCH 03/11] cirrus/mac89x0: print MAC via printk format specifier
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 11:15, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Feb 24, 2012 at 14:45, Danny Kukawka <danny.kukawka@bisect.de> wrote:
>> Print MAC/dev_addr via printk extended format specifier %pM instead
>> of custom code.
>>
>> Use memcpy to set the address to dev->dev_addr in set_mac_address,
>> instead of mxing it up in a for loop with printing a debug msg.
>>
>> Check also if the given address is valid.
>
> Why do you sneak in this check in this patch?

And it doesn't compile:

http://kisskb.ellerman.id.au/kisskb/buildresult/5752157/

drivers/net/ethernet/cirrus/mac89x0.c: In function ‘set_mac_address’:
drivers/net/ethernet/cirrus/mac89x0.c:597: warning: dereferencing
‘void *’ pointer
drivers/net/ethernet/cirrus/mac89x0.c:597: error: request for member
‘sa_data’ in something not a structure or union
drivers/net/ethernet/cirrus/mac89x0.c:600: warning: dereferencing
‘void *’ pointer
drivers/net/ethernet/cirrus/mac89x0.c:600: error: request for member
‘sa_data’ in something not a structure or union
drivers/net/ethernet/cirrus/mac89x0.c:595: warning: unused variable ‘saddr’

No patch included as I don't think this should have been applied as-is.

>> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>> ---
>>  drivers/net/ethernet/cirrus/mac89x0.c |   12 ++++++++----
>>  1 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
>> index 83781f3..a7324ce 100644
>> --- a/drivers/net/ethernet/cirrus/mac89x0.c
>> +++ b/drivers/net/ethernet/cirrus/mac89x0.c
>> @@ -592,10 +592,14 @@ static void set_multicast_list(struct net_device *dev)
>>  static int set_mac_address(struct net_device *dev, void *addr)
>>  {
>>        int i;
>> -       printk("%s: Setting MAC address to ", dev->name);
>> -       for (i = 0; i < 6; i++)
>> -               printk(" %2.2x", dev->dev_addr[i] = ((unsigned char *)addr)[i]);
>> -       printk(".\n");
>> +       struct sockaddr *saddr = addr;
>> +
>> +       if (!is_valid_ether_addr(addr->sa_data))
>> +               return -EADDRNOTAVAIL;
>> +
>> +       memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
>> +       printk("%s: Setting MAC address to %pM\n", dev->name, dev->dev_addr);
>> +
>>        /* set the Ethernet address */
>>        for (i=0; i < ETH_ALEN/2; i++)
>>                writereg(dev, PP_IA+i*2, dev->dev_addr[i*2] | (dev->dev_addr[i*2+1] << 8));

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
