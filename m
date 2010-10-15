Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0JOIaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:30:22 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:50488 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0JOIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:30:21 -0400
Date: Fri, 15 Oct 2010 16:30:13 +0800
From: m00150988@huawei.com
Subject: Re: [PATCH] fix oops in usbserial_cleanup function;
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
        zihan@huawei.com, zihan@huawei.com, Lin Lei <Lin.Lei@huawei.com>,
        Franko Fang <huananhu@huawei.com>, wangyeqi@huawei.com,
        wangyeqi@huawei.com
Message-id: <fadccdfb103f0.103f0fadccdfb@huawei.com>
MIME-version: 1.0
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-Accept-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:ma rui <m00150988@huawei.com>
1. I find this bug on OpenSUSE 11.3 which kernel version is 2.6.34, but the latest kernel version 2.6.36-rc7 aslo have this bug. This patch is based on
the kernel of 2.6.36-rc7
2. bug report:
   a. Install huawei datacard dashboard on OpenSUSE 11.3
   b. Plug in huawei datacard into OpenSUSE 11.3 which kernel version is 2.6.36-rc7
   c. After the dashboard has detected the device, I pull out the usb datacard
   d. Close dashboard,then kernel panic will happen in usbserial_clean function

Yes, the datacard exit without close the port. 

But after the dashboard connect internet with hauwei datacard, then Hibernate/resume, the bug will happen too.
Do you have any other good idea to resolve this bug,or please apply my patch,thanks. :)


Signed-off-by: ma rui <m00150988@huawei.com>


diff -uprN -X linux-2.6.36-rc7_orig/Documentation/dontdiff linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c
--- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c	2010-10-06 16:39:52.000000000 -0400
+++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c	2010-10-15 01:57:36.000000000 -0400
@@ -328,6 +328,16 @@ static void serial_cleanup(struct tty_st
 	/* The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
+	if (NULL == port)
+		return;
+	mutex_lock(&port->serial->disc_mutex);
+	if (port->serial->disconnected) {
+		return_serial(port->serial);
+		mutex_unlock(&port->serial->disc_mutex);
+		return;
+	}
+	mutex_unlock(&port->serial->disc_mutex);
+
 	if (port->port.console)
 		return;
 








----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "marui" <m00150988@huawei.com>
Cc: <linux-usb@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; "Lin Lei" <Lin.Lei@huawei.com>; "Franko Fang" <huananhu@huawei.com>; <wangyeqi@huawei.com>
Sent: Friday, October 15, 2010 12:20 PM
Subject: Re: [PATCH] fix oops in usbserial_cleanup function;


> On Fri, Oct 15, 2010 at 11:50:56AM +0800, marui wrote:
>> 1. I find this bug on OpenSUSE 11.3 which kernel vesion is 2.6.34, but the latest kernel vesion 2.6.36-rc7 aslo have this bug. This patch is based on the kernel of 2.6.36-rc7.
>> 2. Bug report:
>>    a. Install huawei datacard dashboard on OpenSUSE 11.3
>>    b. Plug in huawei datacard into OpenSUSE 11.3 which kernel verison is 2.6.36-rc7
>>    c. After the dashboard has detected the device, I  pull out the usb datacard
>>    d. close datashboard,then kernel panic will happen in usbserial_cleanup function. 
> 
> What does the "dashboard" program do?  Hold the port open?
> 
>> 3. fix the bug:
>>    I find usbserial_cleanup should judge the usb device wheher has been disconnected firtly.
>> 
>> 
>> diff -uprN -X linux-2.6.36-rc7-orig/Documentation/dontdiff linux-2.6.36-rc7-orig/drivers/usb/serial/usb-serial.c linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c
>> 
>> --- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c 2010-10-06 16:39:52.000000000 -0400
>> +++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c 2010-10-14 20:59:47.000000000 -0400
>> @@ -328,6 +328,20 @@ static void serial_cleanup(struct tty_st
>>   /* The console is magical.  Do not hang up the console hardware
>>    * or there will be tears.
>>    */
>> +        dbg("%s start\n",__func__);
>> +        if(NULL == port)
>> +        {
>> +            dbg("%s NULL == port\n",__func__);
>> +            return;
> 
> We don't need to keep the dbg statements here, do we?
> 
>> +        }
>> + mutex_lock(&port->serial->disc_mutex);
>> + if (port->serial->disconnected)
>> +        {
>> +                dbg("%s port->serial->disconnected\n",__func__);
>> +                return_serial(port->serial);
>> +  return;
> 
> You can't return with a lock held.
> 
>> +        }
>> + mutex_unlock(&port->serial->disc_mutex);
>>   if (port->port.console)
>>    return;
> 
> Your tabs and spaces got all mixed up, and it can't be applied.  Also, I
> need a "Signed-off-by:" line to be able to accept it.  Care to read the
> file Documentation/SubmittingPatches for how to format a patch so we can
> take it?
> 
> Also, run the patch through scripts/checkpatch.pl and resolve the coding
> style issues before resending please.
> 
> thanks,
> 
> greg k-h
