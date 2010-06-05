Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0FEKXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:23:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab0FEKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:23:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][PATCH 5/6] Cleanup hrtimer.c's direct access to wall_to_monotonic
Date: Sat, 5 Jun 2010 12:23:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com> <1275706406-8111-5-git-send-email-johnstul@us.ibm.com> <1275706406-8111-6-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1275706406-8111-6-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006051223.06000.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19zG2UVpZBfHwHTokf8japCRt5Ovpt6BX2M/gO
 rL2HoV3hkhqFAx84uflqsIGKU/y/FoPCZULBL7LBflxHGK+7h+
 FVIH3Hz1I24+q8MFwo9rw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, John Stultz wrote:
>         do {
>                 seq = read_seqbegin(&xtime_lock);
>                 xts = __current_kernel_time();
> -               tom = wall_to_monotonic;
> +               tom = __get_wall_to_monotonic();
>         } while (read_seqretry(&xtime_lock, seq));
>  

Would it make sense to also limit the use of xtime_lock to the
timekeeping code? I suppose you could merge the various accessors
(current_kernel_time, get_monotonic_coarse, __current_kernel_time,
__get_wall_to_monotonic) with a single function doing

struct timespec current_kernel_time(struct timespec *tomono)
{
        struct timespec now;
        unsigned long seq;

        do {
                seq = read_seqbegin(&xtime_lock);
		if (tomono)
			wall_to_monotonic;
                now = xtime;
        } while (read_seqretry(&xtime_lock, seq));

        return now;
}

	Arnd
