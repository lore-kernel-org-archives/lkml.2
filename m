Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965806Ab2FATMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:12:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965770Ab2FATMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:12:12 -0400
Date: Fri, 1 Jun 2012 12:11:59 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-9fa7dedad3d30345c843bd82db02c4d6169e5f61@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, the.ridikulus.rat@gmail.com, tglx@linutronix.de,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, the.ridikulus.rat@gmail.com,
        tglx@linutronix.de, matt.fleming@intel.com
In-Reply-To: <1331907517-3985-3-git-send-email-matt@console-pimps.org>
References: <1331907517-3985-3-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi; Add EFI boot stub console support
Git-Commit-ID: 9fa7dedad3d30345c843bd82db02c4d6169e5f61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 01 Jun 2012 12:12:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fa7dedad3d30345c843bd82db02c4d6169e5f61
Gitweb:     http://git.kernel.org/tip/9fa7dedad3d30345c843bd82db02c4d6169e5f61
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Mon, 20 Feb 2012 13:20:59 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 1 Jun 2012 09:11:26 -0700

x86, efi; Add EFI boot stub console support

We need a way of printing useful messages to the user, for example
when we fail to open an initrd file, instead of just hanging the
machine without giving the user any indication of what went wrong. So
sprinkle some error messages throughout the EFI boot stub code to make
it easier for users to diagnose/report problems.

Reported-by: Keshav P R <the.ridikulus.rat@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1331907517-3985-3-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/eboot.c |   85 ++++++++++++++++++++++++++++++-------
 arch/x86/boot/compressed/eboot.h |    6 +++
 2 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 52a4e66..4e85f5f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -16,6 +16,26 @@
 
 static efi_system_table_t *sys_table;
 
+static void efi_printk(char *str)
+{
+	char *s8;
+
+	for (s8 = str; *s8; s8++) {
+		struct efi_simple_text_output_protocol *out;
+		efi_char16_t ch[2] = { 0 };
+
+		ch[0] = *s8;
+		out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
+
+		if (*s8 == '\n') {
+			efi_char16_t nl[2] = { '\r', 0 };
+			efi_call_phys2(out->output_string, out, nl);
+		}
+
+		efi_call_phys2(out->output_string, out, ch);
+	}
+}
+
 static efi_status_t __get_map(efi_memory_desc_t **map, unsigned long *map_size,
 			      unsigned long *desc_size)
 {
@@ -531,8 +551,10 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 				EFI_LOADER_DATA,
 				nr_initrds * sizeof(*initrds),
 				&initrds);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for initrds\n");
 		goto fail;
+	}
 
 	str = (char *)(unsigned long)hdr->cmd_line_ptr;
 	for (i = 0; i < nr_initrds; i++) {
@@ -575,32 +597,42 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 
 			status = efi_call_phys3(boottime->handle_protocol,
 					image->device_handle, &fs_proto, &io);
-			if (status != EFI_SUCCESS)
+			if (status != EFI_SUCCESS) {
+				efi_printk("Failed to handle fs_proto\n");
 				goto free_initrds;
+			}
 
 			status = efi_call_phys2(io->open_volume, io, &fh);
-			if (status != EFI_SUCCESS)
+			if (status != EFI_SUCCESS) {
+				efi_printk("Failed to open volume\n");
 				goto free_initrds;
+			}
 		}
 
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to open initrd file\n");
 			goto close_handles;
+		}
 
 		initrd->handle = h;
 
 		info_sz = 0;
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, NULL);
-		if (status != EFI_BUFFER_TOO_SMALL)
+		if (status != EFI_BUFFER_TOO_SMALL) {
+			efi_printk("Failed to get initrd info size\n");
 			goto close_handles;
+		}
 
 grow:
 		status = efi_call_phys3(sys_table->boottime->allocate_pool,
 					EFI_LOADER_DATA, info_sz, &info);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to alloc mem for initrd info\n");
 			goto close_handles;
+		}
 
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, info);
@@ -612,8 +644,10 @@ grow:
 		file_sz = info->file_size;
 		efi_call_phys1(sys_table->boottime->free_pool, info);
 
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to get initrd info\n");
 			goto close_handles;
+		}
 
 		initrd->size = file_sz;
 		initrd_total += file_sz;
@@ -629,11 +663,14 @@ grow:
 		 */
 		status = high_alloc(initrd_total, 0x1000,
 				   &initrd_addr, hdr->initrd_addr_max);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to alloc highmem for initrds\n");
 			goto close_handles;
+		}
 
 		/* We've run out of free low memory. */
 		if (initrd_addr > hdr->initrd_addr_max) {
+			efi_printk("We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_initrd_total;
 		}
@@ -652,8 +689,10 @@ grow:
 				status = efi_call_phys3(fh->read,
 							initrds[j].handle,
 							&chunksize, addr);
-				if (status != EFI_SUCCESS)
+				if (status != EFI_SUCCESS) {
+					efi_printk("Failed to read initrd\n");
 					goto free_initrd_total;
+				}
 				addr += chunksize;
 				size -= chunksize;
 			}
@@ -732,8 +771,10 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
 			options_size++;	/* NUL termination */
 
 			status = low_alloc(options_size, 1, &cmdline);
-			if (status != EFI_SUCCESS)
+			if (status != EFI_SUCCESS) {
+				efi_printk("Failed to alloc mem for cmdline\n");
 				goto fail;
+			}
 
 			s1 = (u8 *)(unsigned long)cmdline;
 			s2 = (u16 *)options;
@@ -895,12 +936,16 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 
 	status = efi_call_phys3(sys_table->boottime->handle_protocol,
 				handle, &proto, (void *)&image);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		goto fail;
+	}
 
 	status = low_alloc(0x4000, 1, (unsigned long *)&boot_params);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc lowmem for boot params\n");
 		goto fail;
+	}
 
 	memset(boot_params, 0x0, 0x4000);
 
@@ -933,8 +978,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 	if (status != EFI_SUCCESS) {
 		status = low_alloc(hdr->init_size, hdr->kernel_alignment,
 				   &start);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to alloc mem for kernel\n");
 			goto fail;
+		}
 	}
 
 	hdr->code32_start = (__u32)start;
@@ -945,19 +992,25 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for gdt structure\n");
 		goto fail;
+	}
 
 	gdt->size = 0x800;
 	status = low_alloc(gdt->size, 8, (unsigned long *)&gdt->address);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for gdt\n");
 		goto fail;
+	}
 
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, sizeof(*idt),
 				(void **)&idt);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for idt structure\n");
 		goto fail;
+	}
 
 	idt->size = 0;
 	idt->address = 0;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index 3925166..3b6e156 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -58,4 +58,10 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
+struct efi_simple_text_output_protocol {
+	void *reset;
+	void *output_string;
+	void *test_string;
+};
+
 #endif /* BOOT_COMPRESSED_EBOOT_H */
