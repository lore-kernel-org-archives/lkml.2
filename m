Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2KMIMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:12:44 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59545 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2KMIMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:12:43 -0500
MIME-Version: 1.0
In-Reply-To: <CABawtvMtO5NR-j3zX2xxXfgZ_XxrCdF+k+n4jG3KyEVe=xYjjA@mail.gmail.com>
References: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com>
	<alpine.DEB.2.00.1205222029590.28165@chino.kir.corp.google.com>
	<CABawtvM-ZzFvT3LLb5V2bm52odeSyxeQwwvbVXgrNcMX5WMrbQ@mail.gmail.com>
	<alpine.DEB.2.00.1205232142120.10366@chino.kir.corp.google.com>
	<CABawtvMtO5NR-j3zX2xxXfgZ_XxrCdF+k+n4jG3KyEVe=xYjjA@mail.gmail.com>
Date: Tue, 13 Nov 2012 16:12:42 +0800
Message-ID: <CABawtvOC8grVSB6oXb1snsncuku+HtyaRjCUMkaiPaVfPurr7w@mail.gmail.com>
Subject: Re: ACPI and NUMA guys, please help to check if this patch is OK
From: Ethan Zhao <ethan.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
   I come back to suggest the above again because I hit the same issue
on another type server and that took me sometime to find out what's
wrong for no clear information when validating the SLIT. That patch
will not invalidate the SRAT if SLIT is bad.  The patch will only
suppress the optional SLIT table if the table has more or less
PXM(locality) than SRAT.

[PATCH] drivers/acpi/numa.c: Add localities checking code against
proximity domains to slit_valid()

 Some buggy BIOS/ACPI will set different number to SLIT localities and
SRAT proximity domains,
 That will make NUMA configuration invalid and kernel will output
information like following

NUMA:Warning:invalid distance parameter, from=-1 to=-1 distance=83

This patch adds some checking code to slit_valid() function in order
to check theSLIT localities
count against SRAT proximity domains number and give clear information
about ACPI bug.

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/acpi/numa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index e56f3be..55c8a8e 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -161,6 +161,13 @@ static __init int slit_valid(struct acpi_table_slit *slit)
 {
        int i, j;
        int d = slit->locality_count;
+       int pxd = nodes_weight(nodes_found_map);
+       if (pxd != d) {
+               printk(KERN_INFO "ACPI: BIOS bug! SLIT localities
count %d doesn't equal SRAT proximity domains number %d\n",
+                       d , pxd);
+               return 0;
+       }
+
        for (i = 0; i < d; i++) {
                for (j = 0; j < d; j++)  {
                        u8 val = slit->entry[d*i + j];
--
1.7.1


Thanks,
Ethan

On Thu, May 24, 2012 at 12:59 PM, ethan zhao <ethan.kernel@gmail.com> wrote:
> That is OK，
> Thanks
>
> On Thu, May 24, 2012 at 12:45 PM, David Rientjes <rientjes@google.com> wrote:
>> On Thu, 24 May 2012, ethan zhao wrote:
>>
>>> David,
>>>     What we can do to help improving Linux OS is only about fatal
>>> error ? Can I do something to give more clear warning information and
>>> easy to find the root cause ?
>>>
>>
>> The warning you already quoted in your changelog is sufficient warning
>> that the SLIT is bad and it suppresses setting that distance.  Your
>> change, however, completely invalidates the SRAT if the number of
>> localities does not match the number of pxms.  We'd much rather simply
>> suppress the bad distance rather than invalidate the SRAT, especially
>> considering there is nothing in the ACPI spec that requires it.
