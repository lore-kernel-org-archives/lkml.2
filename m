Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab1EZRpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1EZRpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:45:39 -0400
Date: Thu, 26 May 2011 13:44:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE
 generated crashes
Message-ID: <20110526174447.GC29496@redhat.com>
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172305.GA18295@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526172305.GA18295@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> 
> slimdump: Capture slimdump for fatal MCE generated crashes
> 
> System crashes resulting from fatal hardware errors (such as MCE) don't need
> all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> retains only essential information while discarding the old memory.
> 

Why to enforce zeroing out of rest of the vmcore data in kernel. Why not
leave it to user space. 

As Andi said, you anyway will require disabling MCE temporarily in second
kernel. So that should allay the concern that we might run into second
MCE while trying to read the vmcore.

A user might want to extract just the dmesg buffers also after MCE from
vmcore.

What I am saying is that this sounds more like a policy. Don't enforce
it in kernel. Probably give user MCE registers as part of ELF note of
vmcore. Now leave it up to user what data he wants to extract from vmcore.
Just the MCE registers or something more then that.

Thanks
Vivek

> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  fs/proc/vmcore.c |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 128 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.slim_kdump/fs/proc/vmcore.c
> ===================================================================
> --- linux-2.6.slim_kdump.orig/fs/proc/vmcore.c
> +++ linux-2.6.slim_kdump/fs/proc/vmcore.c
> @@ -483,9 +483,60 @@ static void __init set_vmcore_list_offse
>  	}
>  }
>  
> +/*
> + * Check if the crash was due to a fatal Memory Check Exception
> + */
> +static int is_mce_crash64(void)
> +{
> +	int i, j, len = 0, rc;
> +	Elf64_Ehdr *ehdr_ptr;
> +	Elf64_Phdr *phdr_ptr;
> +	Elf64_Nhdr *nhdr_ptr;
> +
> +	ehdr_ptr = (Elf64_Ehdr *)elfcorebuf;
> +	phdr_ptr = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
> +
> +	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
> +		void *notes_section;
> +		u64 offset, max_sz;
> +		if (phdr_ptr->p_type != PT_NOTE)
> +			continue;
> +		max_sz = phdr_ptr->p_memsz;
> +		offset = phdr_ptr->p_offset;
> +		notes_section = kmalloc(max_sz, GFP_KERNEL);
> +		if (!notes_section)
> +			return -ENOMEM;
> +		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
> +		if (rc < 0) {
> +			kfree(notes_section);
> +			return rc;
> +		}
> +
> +		for (j = 0; j < phdr_ptr->p_filesz; j += len) {
> +			nhdr_ptr = notes_section + j;
> +			if (nhdr_ptr->n_type == NT_MCE)
> +			{
> +				kfree(notes_section);
> +				return 1;
> +			}
> +			/*
> +			 * The elf-64 standard specifies 8-byte alignment while
> +			 * append_elf_note function does only 4-byte roundup.
> +			 * Hence this code also does a 4-byte roundup.
> +			 */
> +			len = sizeof(Elf64_Nhdr);
> +			len = roundup(len + nhdr_ptr->n_namesz, 4);
> +			len = roundup(len + nhdr_ptr->n_descsz, 4);
> +		}
> +		kfree(notes_section);
> +	}
> +	return 0;
> +}
> +
>  static int __init parse_crash_elf64_headers(void)
>  {
> -	int rc=0;
> +	int i, rc = 0;
> +	Elf64_Phdr *phdr_ptr;
>  	Elf64_Ehdr ehdr;
>  	u64 addr;
>  
> @@ -523,6 +574,18 @@ static int __init parse_crash_elf64_head
>  		return rc;
>  	}
>  
> +	phdr_ptr = (Elf64_Phdr *)(elfcorebuf + sizeof(Elf64_Ehdr));
> +	if (is_mce_crash64() > 0) {
> +		/*
> +		 * If crash is due to Machine Check exception, don't populate
> +		 * sections other than elf-notes. Mark their sizes as zero.
> +		 */
> +		for (i = 0; i < ehdr.e_phnum; i++, phdr_ptr++) {
> +			if (phdr_ptr->p_type != PT_NOTE)
> +				phdr_ptr->p_memsz = phdr_ptr->p_filesz = 0;
> +		}
> +	}
> +
>  	/* Merge all PT_NOTE headers into one. */
>  	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
>  	if (rc) {
> @@ -539,9 +602,60 @@ static int __init parse_crash_elf64_head
>  	return 0;
>  }
>  
> +/*
> + * Check if the crash was due to a fatal Memory Check Exception
> + */
> +static int is_mce_crash32(void)
> +{
> +	int i, j, len = 0, rc;
> +	Elf32_Ehdr *ehdr_ptr;
> +	Elf32_Phdr *phdr_ptr;
> +	Elf32_Nhdr *nhdr_ptr;
> +
> +	ehdr_ptr = (Elf32_Ehdr *)elfcorebuf;
> +	phdr_ptr = (Elf32_Phdr *)(elfcorebuf + sizeof(Elf32_Ehdr));
> +
> +	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
> +		void *notes_section;
> +		u64 offset, max_sz;
> +		if (phdr_ptr->p_type != PT_NOTE)
> +			continue;
> +		max_sz = phdr_ptr->p_memsz;
> +		offset = phdr_ptr->p_offset;
> +		notes_section = kmalloc(max_sz, GFP_KERNEL);
> +		if (!notes_section)
> +			return -ENOMEM;
> +		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
> +		if (rc < 0) {
> +			kfree(notes_section);
> +			return rc;
> +		}
> +
> +		for (j = 0; j < phdr_ptr->p_filesz; j += len) {
> +			nhdr_ptr = notes_section + j;
> +			if (nhdr_ptr->n_type == NT_MCE)
> +			{
> +				kfree(notes_section);
> +				return 1;
> +			}
> +			/*
> +			 * The elf-64 standard specifies 8-byte alignment while
> +			 * append_elf_note function does only 4-byte roundup.
> +			 * Hence this code also does a 4-byte roundup.
> +			 */
> +			len = sizeof(Elf64_Nhdr);
> +			len = roundup(len + nhdr_ptr->n_namesz, 4);
> +			len = roundup(len + nhdr_ptr->n_descsz, 4);
> +		}
> +		kfree(notes_section);
> +	}
> +	return 0;
> +}
> +
>  static int __init parse_crash_elf32_headers(void)
>  {
> -	int rc=0;
> +	int i, rc = 0;
> +	Elf32_Phdr *phdr_ptr;
>  	Elf32_Ehdr ehdr;
>  	u64 addr;
>  
> @@ -579,6 +693,18 @@ static int __init parse_crash_elf32_head
>  		return rc;
>  	}
>  
> +	phdr_ptr = (Elf32_Phdr *)(elfcorebuf + sizeof(Elf32_Ehdr));
> +	if (is_mce_crash32() > 0) {
> +		/*
> +		 * If crash is due to Machine Check exception, don't populate
> +		 * sections other than elf-notes. Mark their sizes as zero.
> +		 */
> +		for (i = 0; i < ehdr.e_phnum; i++, phdr_ptr++) {
> +			if (phdr_ptr->p_type != PT_NOTE)
> +				phdr_ptr->p_memsz = phdr_ptr->p_filesz = 0;
> +		}
> +	}
> +
>  	/* Merge all PT_NOTE headers into one. */
>  	rc = merge_note_headers_elf32(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
>  	if (rc) {
