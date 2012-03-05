Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2CEKSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:18:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55705 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418Ab2CEKSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:18:33 -0500
X-Sasl-enc: /SpHp2JW24KHhaO5rmNQnpGCLVmrrNHky+/gI+nZ3TLO 1330942711
Date: Mon, 5 Mar 2012 07:18:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH V3] cpuidle: Add a sysfs entry to disable specific C
 state for debug purpose.
Message-ID: <20120305101827.GA19408@khazad-dum.debian.net>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
 <1330647453.1916.7.camel@ymzhang>
 <20120302142303.648285a7.akpm@linux-foundation.org>
 <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
 <4F545A4E.8010801@linux.vnet.ibm.com>
 <4F5466C4.2090808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5466C4.2090808@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2012, ShuoX Liu wrote:
> @@ -45,6 +46,7 @@ total 0
>  /sys/devices/system/cpu/cpu0/cpuidle/state1:
>  total 0
>  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
> +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
>  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
>  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
>  -r--r--r-- 1 root root 4096 Feb  8 10:42 power

...

> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index 3fe41fe..1eae29a 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
>  #define define_one_state_ro(_name, show) \
>  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
> show, NULL)
> 
> +#define define_one_state_rw(_name, show, store) \
> +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
> show, store)
> +
>  #define define_show_state_function(_name) \
>  static ssize_t show_state_##_name(struct cpuidle_state *state, \
>  			 struct cpuidle_state_usage *state_usage, char *buf) \
> @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
> cpuidle_state *state, \
>  	return sprintf(buf, "%u\n", state->_name);\
>  }
> 
> +#define define_store_state_function(_name) \
> +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> +		const char *buf, size_t size) \
> +{ \
> +	int value; \
> +	sscanf(buf, "%d", &value); \
> +	if (value) \
> +		state->disable = 1; \
> +	else \
> +		state->disable = 0; \
> +	return size; \
> +}

Isn't this missing a check for capabilities?  Disabling cpuidle states is
not something random Joe (and IMHO that does mean random capability-
restricted Joe root) should be doing...

Also, maybe it would be best to use one of the lib helpers to parse that
value, so that it will be less annoying to userspace (trim blanks, complain
if there is trailing junk after trimming, etc)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
