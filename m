Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab2CZSVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:21:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49808 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2CZSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:21:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6661"; a="173596833"
Message-ID: <4F70B3B2.7090509@codeaurora.org>
Date: Mon, 26 Mar 2012 11:21:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/6] firmware_class: Split _request_firmware() into three
 functions
References: <201203032122.36745.chunkeey@googlemail.com> <201203200000.43316.rjw@sisk.pl> <201203260000.34377.rjw@sisk.pl> <201203260001.46109.rjw@sisk.pl> <4F70B25E.60505@codeaurora.org>
In-Reply-To: <4F70B25E.60505@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/12 11:15, Stephen Boyd wrote:
> On 03/25/12 15:01, Rafael J. Wysocki wrote:
>>  drivers/base/firmware_class.c |   57 +++++++++++++++++++++++++++++-------------
>>  1 file changed, 40 insertions(+), 17 deletions(-)
>>
>> Index: linux/drivers/base/firmware_class.c
>> ===================================================================
>> --- linux.orig/drivers/base/firmware_class.c
>> +++ linux/drivers/base/firmware_class.c
>> @@ -435,7 +435,7 @@ static void firmware_class_timeout(u_lon
>>  }
>>  
>>  static struct firmware_priv *
>> -fw_create_instance(struct firmware *firmware, const char *fw_name,
>> +fw_create_instance(const struct firmware *firmware, const char *fw_name,
>>  		   struct device *device, bool uevent, bool nowait)
>>  {
>>  	struct firmware_priv *fw_priv;
>> @@ -449,7 +449,7 @@ fw_create_instance(struct firmware *firm
>>  		goto err_out;
>>  	}
>>  
>> -	fw_priv->fw = firmware;
>> +	fw_priv->fw = (struct firmware *)firmware;
>>  	fw_priv->nowait = nowait;
>>  	strcpy(fw_priv->fw_id, fw_name);
>>  	init_completion(&fw_priv->completion);
> Can we avoid this cast? If we do some parts of fw_create_instance()
> during the setup phase I think we can avoid it.
>

Oops. With the other patch you can squash this in to do what I
originally talked about.

-----8<-----
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index fbe98a8..113d37d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -435,7 +435,7 @@ static void firmware_class_timeout(u_long data)
 }
 
 static struct firmware_priv *
-fw_create_instance(const struct firmware *firmware, const char *fw_name,
+fw_create_instance(struct firmware *firmware, const char *fw_name,
                   struct device *device, bool uevent, bool nowait)
 {
        struct firmware_priv *fw_priv;
@@ -447,7 +447,7 @@ fw_create_instance(const struct firmware *firmware, const char *fw_name,
                return ERR_PTR(-ENOMEM);
        }
 
-       fw_priv->fw = (struct firmware *)firmware;
+       fw_priv->fw = firmware;
        fw_priv->nowait = nowait;
        strcpy(fw_priv->fw_id, fw_name);
        init_completion(&fw_priv->completion);


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

