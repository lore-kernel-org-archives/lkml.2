Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2EDU7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:59:33 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab2EDUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:48:51 -0400
Message-Id: <20120504204246.438929398@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 18/47] Fix modpost failures in fedora 17
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

commit e88aa7bbbe3046a125ea1936b16bb921cc9c6349 upstream.

The symbol table on x86-64 starts to have entries that have names
like:

_GLOBAL__sub_I_65535_0___mod_x86cpu_device_table

They are of type STT_FUNCTION and this one had a length of 18.  This
matched the device ID validation logic and it barfed because the
length did not meet the device type's criteria.

--------------------
FATAL: arch/x86/crypto/aesni-intel: sizeof(struct x86cpu_device_id)=16 is not a modulo of the size of section __mod_x86cpu_device_table=18.
Fix definition of struct x86cpu_device_id in mod_devicetable.h
--------------------

These are some kind of compiler tool internal stuff being emitted and
not something we want to inspect in modpost's device ID table
validation code.

So skip the symbol if it is not of type STT_OBJECT.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Thanks,
Jonathan

 scripts/mod/file2alias.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -905,6 +905,10 @@ void handle_moddevtable(struct module *m
 	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
+	/* We're looking for an object */
+	if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
+		return;
+
 	/* Handle all-NULL symbols allocated into .bss */
 	if (info->sechdrs[get_secindex(info, sym)].sh_type & SHT_NOBITS) {
 		zeros = calloc(1, sym->st_size);


