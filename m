Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070Ab2JaIU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:20:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58065 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934975Ab2JaIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:20:21 -0400
Message-ID: <5090DF3F.5030600@numascale-asia.com>
Date: Wed, 31 Oct 2012 16:20:15 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AMD64 EDAC: Add support for >255 memory controllers
References: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com> <1351662932-22279-2-git-send-email-daniel@numascale-asia.com> <CAPVoSvTz4=dabySPCjjR3yED_QnC_OwhJUZjQty6zYH4=FKVgg@mail.gmail.com>
In-Reply-To: <CAPVoSvTz4=dabySPCjjR3yED_QnC_OwhJUZjQty6zYH4=FKVgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/2012 16:18, Torsten Kaiser wrote:
> On Wed, Oct 31, 2012 at 6:55 AM, Daniel J Blueman
> <daniel@numascale-asia.com> wrote:
>> As the AMD64 last-level-cache ID is 16-bits and federated systems
>> eg using Numascale's NumaConnect/NumaChip can have more than 255 memory
>> controllers, use 16-bits to store the ID.
>>
>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
>> ---
>>   drivers/edac/amd64_edac.c |   18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index 18d404a..9920dfd 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -942,7 +942,7 @@ static u64 get_error_address(struct mce *m)
>>                  struct amd64_pvt *pvt;
>>                  u64 cc6_base, tmp_addr;
>>                  u32 tmp;
>> -               u8 mce_nid, intlv_en;
>> +               u16 mce_nid, intlv_en;
>
> Is the change of intlv_en to u16 intentional?
> I assume its not, because...

It's unintentional. Elsewhere, intlv_en is declared as unsigned, so 
perhaps that should be cleaned up later too.

I'll issue an updated patch.

>>                  if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
>>                          return addr;
>> @@ -1499,7 +1499,7 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>>          u8 channel;
>>          bool high_range = false;
>>
>> -       u8 node_id    = dram_dst_node(pvt, range);
>> +       u16 node_id   = dram_dst_node(pvt, range);
>>          u8 intlv_en   = dram_intlv_en(pvt, range);
>
> ... here you keep it at u8.
>
>>          u32 intlv_sel = dram_intlv_sel(pvt, range);
>>
>> @@ -2306,7 +2306,7 @@ out:
>>          return ret;
>>   }
>>
>> -static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
>> +static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
>>   {
>>          cpumask_var_t cmask;
>>          int cpu;
>> @@ -2344,7 +2344,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
>>          return 0;
>>   }
>>
>> -static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
>> +static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
>>                                         struct pci_dev *F3)
>>   {
>>          bool ret = true;
>> @@ -2396,7 +2396,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
>>          return ret;
>>   }
>>
>> -static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
>> +static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
>>                                          struct pci_dev *F3)
>>   {
>>          u32 value, mask = 0x3;          /* UECC/CECC enable */
>> @@ -2435,7 +2435,7 @@ static const char *ecc_msg =
>>          "'ecc_enable_override'.\n"
>>          " (Note that use of the override may cause unknown side effects.)\n";
>>
>> -static bool ecc_enabled(struct pci_dev *F3, u8 nid)
>> +static bool ecc_enabled(struct pci_dev *F3, u16 nid)
>>   {
>>          u32 value;
>>          u8 ecc_en = 0;
>> @@ -2556,7 +2556,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
>>          struct mem_ctl_info *mci = NULL;
>>          struct edac_mc_layer layers[2];
>>          int err = 0, ret;
>> -       u8 nid = get_node_id(F2);
>> +       u16 nid = get_node_id(F2);
>>
>>          ret = -ENOMEM;
>>          pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
>> @@ -2647,7 +2647,7 @@ err_ret:
>>   static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
>>                                               const struct pci_device_id *mc_type)
>>   {
>> -       u8 nid = get_node_id(pdev);
>> +       u16 nid = get_node_id(pdev);
>>          struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
>>          struct ecc_settings *s;
>>          int ret = 0;
>> @@ -2697,7 +2697,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
>>   {
>>          struct mem_ctl_info *mci;
>>          struct amd64_pvt *pvt;
>> -       u8 nid = get_node_id(pdev);
>> +       u16 nid = get_node_id(pdev);
>>          struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
>>          struct ecc_settings *s = ecc_stngs[nid];
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
