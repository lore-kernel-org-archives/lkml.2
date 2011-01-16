Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1APThz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:37:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15914 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1APThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:37:53 -0500
Date: Sun, 16 Jan 2011 20:37:52 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-acpi@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH] ACPI: Fix memory leak in
 acpi_ev_asynch_execute_gpe_method().
Message-ID: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will leak the memory allocated to 'local_gpe_event_info' if 
'acpi_ut_acquire_mutex()' fails or if 'acpi_ev_valid_gpe_event()' fails in 
drivers/acpi/acpica/evgpe.c::acpi_ev_asynch_execute_gpe_method().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 evgpe.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 7c339d3..b6de1fb 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -471,6 +471,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 
 	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
 	if (ACPI_FAILURE(status)) {
+		ACPI_FREE(local_gpe_event_info);
 		return_VOID;
 	}
 
@@ -478,6 +479,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 
 	if (!acpi_ev_valid_gpe_event(gpe_event_info)) {
 		status = acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+		ACPI_FREE(local_gpe_event_info);
 		return_VOID;
 	}
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

