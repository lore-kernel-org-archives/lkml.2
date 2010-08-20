Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0HTT10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:27:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28552 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HTT1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:27:24 -0400
Message-ID: <4C6ED6CD.4010002@kernel.org>
Date: Fri, 20 Aug 2010 12:26:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] [Patch-next] ACPI, APEI, ERST Fix the wrong checking
 of Serialization Header's length
References: <4C69DDB5.6060103@np.css.fujitsu.com>	 <1282008836.2744.1490.camel@yhuang-dev>	 <4C69F094.1040607@np.css.fujitsu.com>	 <1282015344.2744.1500.camel@yhuang-dev> <4C6A139D.20507@np.css.fujitsu.com> <1282109696.2744.1553.camel@yhuang-dev>
In-Reply-To: <1282109696.2744.1553.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 10:34 PM, Huang Ying wrote:
> On Tue, 2010-08-17 at 12:44 +0800, Jin Dongming wrote:
>> (2010/08/17 12:22), Huang Ying wrote:
>>> On Tue, 2010-08-17 at 10:14 +0800, Jin Dongming wrote:
>>>>> I don't think it is necessary to change the header definition, and
>>>>> seri_header is not a good name for me.
>>>> Why I added this structure here is that I don't want to do following checking.
>>>> For example,
>>>> 	if (header_length != 0x0c) {
>>>> 		...
>>>> 	}
>>>
>>> This can be:
>>>
>>>  static int erst_check_table(struct acpi_table_erst *erst_tab)
>>>  {
>>> -       if (erst_tab->header_length != sizeof(struct acpi_table_erst))
>>> +       if (erst_tab->header_length !=
>>> +           (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
>>>
>>> like Yinghai has been done.
>>>
>> Yes. It looks good. And I am sorry I am unaware of Yinghai' patch. 
> 
> Maybe you can help push this fix in, it seems that Yinghai is busy on
> something else?
> 
> Hi, Yinghai,
> 
> Do you mind for Dongming to push this fix?
> 
do you mean this one?

[PATCH] acpi: fix apei related table size checking

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/apei/einj.c |    3 ++-
 drivers/acpi/apei/erst.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/apei/einj.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/einj.c
+++ linux-2.6/drivers/acpi/apei/einj.c
@@ -426,7 +426,8 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fop
 
 static int einj_check_table(struct acpi_table_einj *einj_tab)
 {
-	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
+	if (einj_tab->header_length !=
+	    (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))
 		return -EINVAL;
 	if (einj_tab->header.length < sizeof(struct acpi_table_einj))
 		return -EINVAL;
Index: linux-2.6/drivers/acpi/apei/erst.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/erst.c
+++ linux-2.6/drivers/acpi/apei/erst.c
@@ -750,7 +750,8 @@ __setup("erst_disable", setup_erst_disab
 
 static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
-	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
+	if (erst_tab->header_length !=
+	    (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
 		return -EINVAL;
 	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
 		return -EINVAL;
