Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2EBIdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:33:00 -0400
Received: from chost02.esudo.com ([65.49.35.222]:58272 "EHLO chost02.esudo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2EBIc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:32:58 -0400
X-Greylist: delayed 1358 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 04:32:58 EDT
Message-ID: <4FA0EBE8.5030805@savarinetworks.com>
Date: Wed, 02 May 2012 14:10:16 +0600
From: "dev@savarinetworks.com" <dev@savarinetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: rtc: restoring of periodic irq freqeuncy to original state
Content-Type: multipart/mixed;
 boundary="------------000107090008040103090304"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - chost02.esudo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - savarinetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000107090008040103090304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kernel Folks,

Dont' know whether this is a bug or feature. sorry :(.

when the periodic irq's are enabled from the application through the 
ioctl, and when the application suddenly stops, the irq frequency was 
not reverted back to the original one.

say for ex..
            if my original freq was 1024, and i set it using IRQP_SET 
with 512.
            so when i stop my program the original freq was not set back 
and the program set frequency is appearing in the /proc/driver/rtc.

Attached is the test program.


Thanks,
Devendra C.


--------------000107090008040103090304
Content-Type: text/x-csrc;
 name="hwclock_freq_timer.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hwclock_freq_timer.c"

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/rtc.h>

main()
{
    struct rtc_time rtc_time;
    int fd;
    char data[BUFSIZ];
    int irqfre;
    int ret;

    fd = open("/dev/rtc", O_RDWR);
    if (fd < 0) {
        printf("can't open /dev/rtc\n");
        return;
    }

    ret = ioctl(fd, RTC_IRQP_READ, &irqfre);
    if (ret == 0) {
        /*
        printf("Rate: %d\n", irqfre);
        */
        irqfre =  1024;
        ret = ioctl(fd, RTC_IRQP_SET, irqfre);
    }
    if (ret < 0) {
        printf("Can't read periodic IRQ's\n");
    }

    ret = ioctl(fd, RTC_PIE_ON, NULL);
    if (ret < 0) {
        printf("can't set the periodic irq\n");
        close(fd);
        return;
    }

    
    while(read(fd, &data, sizeof(data)) > 0) {
        printf("Intr\n");
    }
    
}

--------------000107090008040103090304--
