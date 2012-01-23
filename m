Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2AWPKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:10:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:41469 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab2AWPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:10:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
	<1326717103-10287-1-git-send-email-jolsa@redhat.com>
	<1326717103-10287-6-git-send-email-jolsa@redhat.com>
Date: Mon, 23 Jan 2012 07:13:24 -0800
In-Reply-To: <1326717103-10287-6-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 16 Jan 2012 13:31:39 +0100")
Message-ID: <m1bopupi3v.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18k84PRwWb1fq70SHj03ZKVLSot2x8DqPU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> Adding 'format' attribute for pmu device that contains
> a syntax description on how to construct raw events.
>
> The event configuration is described in following
> struct pefr_event_attr attributes:
>
>   config
>   config1
>   config2
>
> Each line of the format file describes mapping of name
> and bitfield definition within one of abve attributes.
>
> eg:
>   event   config:0-7
>   umask   config:8-15
>   usr     config:16
>   os      config:17
>   edge    config:18
>   any     config:21
>   inv     config:23
>   cmask   config:24-31
>
> Line syntax:
>   line:      NAME config ':' bits
>   config:    'config' | 'config1' | 'config2"
>   bits:      bits ',' bit_term | bit_term
>   bit_term:  VALUE '-' VALUE | VALUE
>
> Adding event_format callback to the struct pmu, which provides
> the format information. The pmu shall override this function
> and provide its own specific format information.
>
> If not overloaded the default format information is used:
>
>   config  config:0-63
>   config1 config1:0-63
>   config2 config2:0-63
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

> @@ -5492,8 +5492,31 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
>  	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
>  }
>  
> +static ssize_t perf_default_event_format(struct pmu *pmu, char *page)
> +{
> +	ssize_t ret;
> +
> +	ret  = sprintf(page,       "config  config:0-63\n");
> +	ret += sprintf(page + ret, "config1 config1:0-63\n");
> +	ret += sprintf(page + ret, "config2 config2:0-63\n");

This looks like abuse of sysfs.  The rule is one value per file.
When you start adding newlines I can't see how this format attribute can
be considered one value.

Eric
