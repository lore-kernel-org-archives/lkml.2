Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2A0VIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:08:46 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49074 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2A0VIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:08:45 -0500
Message-ID: <4F231256.8080905@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 13:08:38 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com> <1327674868-10486-1-git-send-email-jolsa@redhat.com> <1327674868-10486-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1327674868-10486-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012721-2398-0000-0000-000003BDE3D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 06:34 AM, Jiri Olsa wrote:
> Adding sysfs group 'format' attribute for pmu device that
> contains a syntax description on how to construct raw events.
> 
> The event configuration is described in following
> struct pefr_event_attr attributes:
> 
>   config
>   config1
>   config2
> 
> Each sysfs attribute within the format attribute group,
> describes mapping of name and bitfield definition within
> one of above attributes.
> 
> eg:
>   "/sys/...<dev>/format/event" contains "config:0-7"
>   "/sys/...<dev>/format/umask" contains "config:8-15"
>   "/sys/...<dev>/format/usr"   contains "config:16"
> 
> the attribute value syntax is:
> 
>   line:      config ':' bits
>   config:    'config' | 'config1' | 'config2"
>   bits:      bits ',' bit_term | bit_term
>   bit_term:  VALUE '-' VALUE | VALUE
> 
> Adding format_defined bool to the struct pmu to specify wether
> pmu defines its own set of format attributes (within the
> attr_groups member) or the default format attributes should be
> used:
>   "/sys/...<dev>/format/config"  contains "config:0-63"
>   "/sys/...<dev>/format/config1" contains "config1:0-63"
>   "/sys/...<dev>/format/config2" contains "config2:0-63"


Hi Jiri,

I've been out of the perf_events loop for some time, but I did finally
notice your patch series thread.

I think what you've done is very good and I'm excited to see progress in
this area.  However, it's not clear to me that it is as generalized as
it needs to be for some PMU's.  I say this because not all events on a
given PMU will have the same needed fields.

As an example, the IBM PowerEN processor has roughly 20 different PMU's
on it.  Some of those PMU's are quite complex and divide their events up
into subsets, each with different fields.  For example, some events may
have a PID matching field, and others may have an bus number matching
field, or matching mode field, etc.  The fields are different widths,
and may overlap in the config/1/2 space.

It seems that there are two approaches you could take:

1) Keep your format, but allow the fields to overlap in the bit space.
For example:

  "/sys/...<dev>/format/event" contains "config:0-7"
  "/sys/...<dev>/format/pidmatch" contains "config:8-15"
  "/sys/...<dev>/format/busmatch"   contains "config:8-13"

Note that busmatch overlaps pidmatch

2) Create event groups that have their overlapping config space
separated out:

  "/sys/...<dev>/format/event" contains "config:0-7"

  "/sys/...<dev>.1/format/pidmatch" contains "config:8-15"

  "/sys/...<dev>.2/format/busmatch"   contains "config:8-13"


Notice the .1 and .2 on the <dev>.

This might help the user understand which fields go together.  I'm not
sold on the .1 syntax... you could do it as <dev>.<event-group-name>/ or
<dev>/<event-group-name>/... or whatever seems to make the most sense
and is relatively easy to implement and use.

- Corey

