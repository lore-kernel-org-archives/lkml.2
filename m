Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1DBHlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:41:23 -0400
Received: from toro.web-alm.net ([62.245.132.31]:48220 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1DBHlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:41:22 -0400
Message-ID: <4D96D147.60607@osadl.org>
Date: Sat, 02 Apr 2011 09:33:27 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>, Greg KH <gregkh@suse.de>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Intel i7/X 980 freezes with CONFIG_INTEL_IDLE and frequency scaling
References: <20110321204104.GA2702@kroah.com>
In-Reply-To: <20110321204104.GA2702@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

after upgrading a Fedora 14 based Intel i7/X 980 box to 2.6.39-rc1, the 
system freezes when frequency scaling is started. Looks like a complete 
CPU halt, since neither SysRq nor anything else can convince the box to 
provide any information.

Loading acpi_cpufreq is save, but selecting the performance 
scaling_governor immediately freezes the system. Selecting the ondemand 
scaling_governor freezes the system when load is generated for the first 
time, presumably when the frequency is increased. Fortunately, when the 
kernel was built with another config file, the system did not freeze. 
After enabling and disabling some suspicious config items (before going 
through the hassle and bisect the config using ktest.pl), the culprit 
was found to be CONFIG_INTEL_IDLE. Fedora 14 enables it.

CPU info:
vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Core(TM) i7 CPU       X 980  @ 3.33GHz
stepping	: 2

Excluding this CPU model from being initialized helps but is, of course, 
no solution. Do you have a real solution?

Thanks,
	Carsten.



--
Index: linux-2.6.39-rc1/drivers/idle/intel_idle.c
===================================================================
--- linux-2.6.39-rc1.orig/drivers/idle/intel_idle.c
+++ linux-2.6.39-rc1/drivers/idle/intel_idle.c
@@ -338,7 +338,9 @@ static int intel_idle_probe(void)
  	case 0x2E:	/* Nehalem-EX Xeon */
  	case 0x2F:	/* Westmere-EX Xeon */
  	case 0x25:	/* Westmere */
+#ifdef WESTMERE_MAY_FREEZE
  	case 0x2C:	/* Westmere */
+#endif
  		cpuidle_state_table = nehalem_cstates;
  		auto_demotion_disable_flags =
  			(NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE);
