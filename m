Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab1D1SSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:18:39 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40615 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1D1SSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:content-transfer-encoding:from:content-type:message-id:date
         :cc:to:mime-version:x-mailer;
        b=JQK0u3BxsN+Ubvdujupr3XJ9ZoVyJP/3TeLhK6oiG8r2DPU7YgxrkTqG++5PJgsZ5i
         cqI8Ci0rrzkLE0lCVj19DYUTSZyUDo9wX1kE4FANeEOAuc8ZUrxgLWbR8psMIxEqsmxL
         Rm79VhCPp9GK087A1TlFZOx8Fm0KXRQxUhgQc=
Subject: ad714x driver help and possible bug
Content-Transfer-Encoding: 8BIT
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <62821D7C-1637-4F7E-A53A-F52AEB2A6C87@gmail.com>
Date: Thu, 28 Apr 2011 14:17:22 -0400
Cc: linux-kernel@vger.kernel.org
To: Barry Song <21cnbao@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am having trouble getting the ad714x (i2c) driver to work in my test setup. I am using the VGA i2c bus to talk to the ad7147 I have. I used INTA of a PCI ethernet slot in my PC. I enabled the PCI device without the driver module loaded.  I then give the interrupt number to ad714x through the struct i2c_board_info. I actually tried the same setup on two PCs, one intel graphics, the other nvidia to eliminate the i2c master as a possible cause of my problem.

The device is successfully loaded and I can see the interrupts going. The eventN device created under /dev/input never spit out anything and so I added printks in the threaded ISR handler to see what is going on.

I only have a wheel with 8 stages. In ad714x_wheel_state_machine() I see that upon the first interrupt, the state goes from IDLE to JITTER. After this the JITTER case checks that c_state == mask (with mask being 0xff in our case). This condition is never met and the driver stays indefinitely in this state. After lifting my finger from the wheel, the chip settles down to scanning every so many milliseconds.

The STAGE_COMPLETE_INT_STATUS is always 0 when my finger is off, but varies a lot while my finger is on (while interrupt frequency is high). Looking at the value of STAGE_COMPLETE_INT_STATUS in binary reveals that the set bits are always in groups, e.g. 0x0007 or 0x001C or 0x0081(I imagine a roll-over of our start_stage-end_stage (0-7)). There seems to be a timing aspect here. I added a spin counter in the threaded ISR to delay reading the 3 registers and that seemed to make the c_state change a little.

I modified the code that reads the 3 registers right after the mutex_lock in ad714x_interrupt_thread so that the STAGE_COMPLETE_INT_STATUS is read before the other two (LOW and HIGH regs). The result was surprising. The COMPLETE reg did read 0xff now and the JITTER case went past the "if(c_state == mask)" but later crashed (divide by 0) in ad714x_wheel_cal_abs_pos() called from the JITTER case.


Here's the initial configuration I give the driver:

static struct ad714x_wheel_plat wheel_platform_data = {
	.start_stage = 0, // int start_stage;
	.end_stage = 7, // int end_stage;
	.max_coord = 128,  // int max_coord;
};

static struct ad714x_platform_data wheel_dev_platform_data = {
	.slider_num = 0,
	.wheel_num = 1,
	.touchpad_num = 0,
	.button_num = 0,
	.slider = 0,
	.wheel = &wheel_platform_data, // struct ad714x_wheel_plat *wheel;
	.touchpad = 0, // struct ad714x_touchpad_plat *touchpad;
	.button = 0, // struct ad714x_button_plat *button;
	.stage_cfg_reg =  { /* unsigned short stage_cfg_reg[STAGE_NUM][STAGE_CFGREG_NUM] */
		{0xfffe, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xfffb, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xffef, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xffbf, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xfeff, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xfbff, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xefff, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
		{0xffff, 0x3ffe, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },

		{0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
		{0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
		{0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
		{0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
	},
	.sys_cfg_reg = {0x027e, 0x00ff, 0x3233, 0x0819, 0x0832, 0x0000, 0x00ff, 0}, /* unsigned short sys_cfg_reg[SYS_CFGREG_NUM] */
	//.sys_cfg_reg = {0x2b2, 0xfff, 0x3233, 0x819, 0x832, 0xcff, 0xcff, 0x0}, /* unsigned short sys_cfg_reg[SYS_CFGREG_NUM] */
};


I also had to change the request_threaded_irq flags to specify IRQF_ONESHOT so the kernel keeps the interrupt masked while we are running ad714x_interrupt_thread(). Otherwise we were getting storms of interrupts each time only one was requested. I am wondering if this should be pulled back to the mainline kernel? 

Thanks for pointers and clues!

