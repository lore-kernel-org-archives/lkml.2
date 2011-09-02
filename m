Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1IBRun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:50:43 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:20529 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1IBRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:50:42 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH] Staging: hv: vmbus: Show the modalias in
 /sys/bus/vmbus/devices/*/
Thread-Topic: [PATCH] Staging: hv: vmbus: Show the modalias in
 /sys/bus/vmbus/devices/*/
Thread-Index: AQHMaY0RFSglJspxWUu3P1/h0ZnnU5U6XZ5w
Date: Fri, 2 Sep 2011 17:50:40 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B604C@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <20110902162556.GA25073@aepfle.de>
In-Reply-To: <20110902162556.GA25073@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p82Hp5jX014803



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, September 02, 2011 12:26 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: [PATCH] Staging: hv: vmbus: Show the modalias in
> /sys/bus/vmbus/devices/*/
> 
> Show a modalias file in /sys/bus/vmbus/devices/*/
> Add a helper function to print the same content in modalias and uevent.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  drivers/staging/hv/vmbus_drv.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -93,6 +93,14 @@ static void get_channel_info(struct hv_d
>  		debug_info.outbound.bytes_avail_towrite;
>  }
> 
> +#define VMBUS_ALIAS_LEN ((sizeof((struct hv_vmbus_device_id *)0)->guid) *
> 2)
> +static void print_alias_name(struct hv_device *hv_dev, char *alias_name)
> +{
> +	int i;
> +	for (i = 0; i < VMBUS_ALIAS_LEN; i += 2)
> +		sprintf(&alias_name[i], "%02x", hv_dev->dev_type.b[i/2]);
> +}
> +
>  /*
>   * vmbus_show_device_attr - Show the device attribute in sysfs.
>   *
> @@ -105,6 +113,7 @@ static ssize_t vmbus_show_device_attr(st
>  {
>  	struct hv_device *hv_dev = device_to_hv_device(dev);
>  	struct hv_device_info device_info;
> +	char alias_name[VMBUS_ALIAS_LEN + 1];
> 
>  	memset(&device_info, 0, sizeof(struct hv_device_info));
> 
> @@ -148,6 +157,9 @@ static ssize_t vmbus_show_device_attr(st
>  			       device_info.chn_instance.b[13],
>  			       device_info.chn_instance.b[14],
>  			       device_info.chn_instance.b[15]);
> +	} else if (!strcmp(dev_attr->attr.name, "modalias")) {
> +		print_alias_name(hv_dev, alias_name);
> +		return sprintf(buf, "vmbus:%s\n", alias_name);
>  	} else if (!strcmp(dev_attr->attr.name, "state")) {
>  		return sprintf(buf, "%d\n", device_info.chn_state);
>  	} else if (!strcmp(dev_attr->attr.name, "id")) {
> @@ -204,6 +216,7 @@ static struct device_attribute vmbus_dev
>  	__ATTR(class_id, S_IRUGO, vmbus_show_device_attr, NULL),
>  	__ATTR(device_id, S_IRUGO, vmbus_show_device_attr, NULL),
>  	__ATTR(monitor_id, S_IRUGO, vmbus_show_device_attr, NULL),
> +	__ATTR(modalias, S_IRUGO, vmbus_show_device_attr, NULL),
> 
>  	__ATTR(server_monitor_pending, S_IRUGO, vmbus_show_device_attr,
> NULL),
>  	__ATTR(server_monitor_latency, S_IRUGO, vmbus_show_device_attr,
> NULL),
> @@ -242,12 +255,10 @@ static struct device_attribute vmbus_dev
>  static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
>  {
>  	struct hv_device *dev = device_to_hv_device(device);
> -	int i, ret;
> -	char alias_name[((sizeof((struct hv_vmbus_device_id *)0)->guid) + 1) *
> 2];
> -
> -	for (i = 0; i < ((sizeof((struct hv_vmbus_device_id *)0)->guid) * 2); i += 2)
> -		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);
> +	int ret;
> +	char alias_name[VMBUS_ALIAS_LEN + 1];
> 
> +	print_alias_name(dev, alias_name);
>  	ret = add_uevent_var(env, "MODALIAS=vmbus:%s", alias_name);
>  	return ret;
>  }

Acked-by:  K. Y. Srinivasan <kys@microsoft.com>


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
