Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1FTWou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:44:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11256 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1FTWos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=raMhaONyC8yYu0YoMcLY9T9/laeNFPiqjaVJCLYG16H/D9UzVTyvPslxLF53fdmk9k
         qpH3UkKjlEqRUIQ+gQIg==
MIME-Version: 1.0
In-Reply-To: <4DFFCCD4.7070403@google.com>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <1307388985-7852-2-git-send-email-mjg@redhat.com> <4DFFCCD4.7070403@google.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 20 Jun 2011 15:44:25 -0700
Message-ID: <BANLkTi=8zDDXLSXV9rxufr9uqciB94xxdnj6s7Q582ZAGZUX5A@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi: Add infrastructure for UEFI 2.0 runtime services
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 3:42 PM, Mike Waychison <mikew@google.com> wrote:
> On 06/06/11 12:36, Matthew Garrett wrote:
>>
>> We're currently missing support for any of the runtime service calls
>> introduced with the UEFI 2.0 spec in 2006. Add the infrastructure for
>> supporting them.
>
> This patch looks like it introduced runtime_version in mainline, but I don't
> see where it gets zero.

Er, I don't see where it gets initialized.

>
>>
>> Signed-off-by: Matthew Garrett<mjg@redhat.com>
>> ---
>>  arch/x86/platform/efi/efi.c |   37 +++++++++++++++++++++++++++++++++++++
>>  include/linux/efi.h         |   32 ++++++++++++++++++++++++++++++++
>>  2 files changed, 69 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index f4f6de9..a0e4244 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -131,6 +131,18 @@ static efi_status_t
>> virt_efi_set_variable(efi_char16_t *name,
>>                              data_size, data);
>>  }
>>
>> +static efi_status_t virt_efi_query_variable_info(u32 attr,
>> +                                                u64 *storage_space,
>> +                                                u64 *remaining_space,
>> +                                                u64 *max_variable_size)
>> +{
>> +       if (efi.runtime_version<  EFI_2_00_SYSTEM_TABLE_REVISION)
>> +               return EFI_UNSUPPORTED;
>> +
>> +       return efi_call_virt4(query_variable_info, attr, storage_space,
>> +                             remaining_space, max_variable_size);
>> +}
>> +
>>  static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
>>  {
>>        return efi_call_virt1(get_next_high_mono_count, count);
>> @@ -145,6 +157,28 @@ static void virt_efi_reset_system(int reset_type,
>>                       data_size, data);
>>  }
>>
>> +static efi_status_t virt_efi_update_capsule(efi_capsule_header_t
>> **capsules,
>> +                                           unsigned long count,
>> +                                           unsigned long sg_list)
>> +{
>> +       if (efi.runtime_version<  EFI_2_00_SYSTEM_TABLE_REVISION)
>> +               return EFI_UNSUPPORTED;
>> +
>> +       return efi_call_virt3(update_capsule, capsules, count, sg_list);
>> +}
>> +
>> +static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t
>> **capsules,
>> +                                               unsigned long count,
>> +                                               u64 *max_size,
>> +                                               int *reset_type)
>> +{
>> +       if (efi.runtime_version<  EFI_2_00_SYSTEM_TABLE_REVISION)
>> +               return EFI_UNSUPPORTED;
>> +
>> +       return efi_call_virt4(query_capsule_caps, capsules, count,
>> max_size,
>> +                             reset_type);
>> +}
>> +
>>  static efi_status_t __init phys_efi_set_virtual_address_map(
>>        unsigned long memory_map_size,
>>        unsigned long descriptor_size,
>> @@ -651,6 +685,9 @@ void __init efi_enter_virtual_mode(void)
>>        efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
>>        efi.reset_system = virt_efi_reset_system;
>>        efi.set_virtual_address_map = NULL;
>> +       efi.query_variable_info = virt_efi_query_variable_info;
>> +       efi.update_capsule = virt_efi_update_capsule;
>> +       efi.query_capsule_caps = virt_efi_query_capsule_caps;
>>        if (__supported_pte_mask&  _PAGE_NX)
>>                runtime_code_page_mkexec();
>>        early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 0758753..ec25726 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -101,6 +101,13 @@ typedef struct {
>>        u64 attribute;
>>  } efi_memory_desc_t;
>>
>> +typedef struct {
>> +       efi_guid_t guid;
>> +       u32 headersize;
>> +       u32 flags;
>> +       u32 imagesize;
>> +} efi_capsule_header_t;
>> +
>>  typedef int (*efi_freemem_callback_t) (u64 start, u64 end, void *arg);
>>
>>  /*
>> @@ -156,6 +163,9 @@ typedef struct {
>>        unsigned long set_variable;
>>        unsigned long get_next_high_mono_count;
>>        unsigned long reset_system;
>> +       unsigned long update_capsule;
>> +       unsigned long query_capsule_caps;
>> +       unsigned long query_variable_info;
>>  } efi_runtime_services_t;
>>
>>  typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
>> @@ -177,6 +187,17 @@ typedef efi_status_t efi_set_virtual_address_map_t
>> (unsigned long memory_map_siz
>>                                                unsigned long
>> descriptor_size,
>>                                                u32 descriptor_version,
>>                                                efi_memory_desc_t
>> *virtual_map);
>> +typedef efi_status_t efi_query_variable_info_t(u32 attr,
>> +                                              u64 *storage_space,
>> +                                              u64 *remaining_space,
>> +                                              u64 *max_variable_size);
>> +typedef efi_status_t efi_update_capsule_t(efi_capsule_header_t
>> **capsules,
>> +                                         unsigned long count,
>> +                                         unsigned long sg_list);
>> +typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t
>> **capsules,
>> +                                             unsigned long count,
>> +                                             u64 *max_size,
>> +                                             int *reset_type);
>>
>>  /*
>>   *  EFI Configuration Table and GUID definitions
>> @@ -218,6 +239,13 @@ typedef struct {
>>
>>  #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
>>
>> +#define EFI_2_30_SYSTEM_TABLE_REVISION  ((2<<  16) | (30))
>> +#define EFI_2_20_SYSTEM_TABLE_REVISION  ((2<<  16) | (20))
>> +#define EFI_2_10_SYSTEM_TABLE_REVISION  ((2<<  16) | (10))
>> +#define EFI_2_00_SYSTEM_TABLE_REVISION  ((2<<  16) | (00))
>> +#define EFI_1_10_SYSTEM_TABLE_REVISION  ((1<<  16) | (10))
>> +#define EFI_1_02_SYSTEM_TABLE_REVISION  ((1<<  16) | (02))
>> +
>>  typedef struct {
>>        efi_table_hdr_t hdr;
>>        unsigned long fw_vendor;        /* physical addr of CHAR16 vendor
>> string */
>> @@ -250,6 +278,7 @@ struct efi_memory_map {
>>   */
>>  extern struct efi {
>>        efi_system_table_t *systab;     /* EFI system table */
>> +       unsigned int runtime_version;   /* Runtime services version */
>>        unsigned long mps;              /* MPS table */
>>        unsigned long acpi;             /* ACPI table  (IA64 ext 0.71) */
>>        unsigned long acpi20;           /* ACPI table  (ACPI 2.0) */
>> @@ -266,6 +295,9 @@ extern struct efi {
>>        efi_get_variable_t *get_variable;
>>        efi_get_next_variable_t *get_next_variable;
>>        efi_set_variable_t *set_variable;
>> +       efi_query_variable_info_t *query_variable_info;
>> +       efi_update_capsule_t *update_capsule;
>> +       efi_query_capsule_caps_t *query_capsule_caps;
>>        efi_get_next_high_mono_count_t *get_next_high_mono_count;
>>        efi_reset_system_t *reset_system;
>>        efi_set_virtual_address_map_t *set_virtual_address_map;
>
>
