Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2JXM2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:28:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:60109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab2JXM2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:28:14 -0400
Message-ID: <1351081662.22332.13.camel@twins>
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
From: Peter Zijlstra <peterz@infradead.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Robert Richter <robert.richter@amd.com>, acme@redhat.com, mingo@kernel.org,
        eranian@google.com, asharma@fb.com,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        mpjohn@us.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2012 14:27:42 +0200
In-Reply-To: <20121016183148.GA25482@us.ibm.com>
References: <20121012012839.GA15348@us.ibm.com>
	 <20121015155534.GR8285@erda.amd.com> <20121016100809.GS8285@erda.amd.com>
	 <20121016183148.GA25482@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 11:31 -0700, Sukadev Bhattiprolu wrote:
> On a side note, how does the kernel on x86 use the 'config' information in 
> say /sys/bus/event_source/devices/cpu/format/cccr ? On Power7, the raw
> code encodes the information such as the PMC to use for the event. Is that
> how the 'config' info in Intel is used ?
> 
> Does the 'config' info change from system to system or is it static for
> a given event on a given CPU ? 

Have a look at commits (tip/master):

  641cc938815dfd09f8fa1ec72deb814f0938ac33
  a47473939db20e3961b200eb00acf5fcf084d755
  43c032febde48aabcf6d59f47cdcb7b5debbdc63


So basically

 /sys/bus/event_source/devices/cpu/format/event

contains something like:

  config:0-7

Which says that for the 'cpu' PMU, field 'event' fills
perf_event_attr::config bits 0 through 7 (for type=PERF_TYPE_RAW).

The perf tool syntax for this is:

  perf stat -e 'cpu/event=0x3c/'

This basically allows you to expose bitfields in the 'raw' event format
for ease of writing raw events. I do not know if the Power PMU has such
or not.

Using this,

  /sys/bus/event_source/devices/cpu/events/cpu-cycles

would contain something like:

  event=0x3c

which one can use as:

  perf stat -e 'cpu/event=cpu-cycles/'
  perf stat -e 'cpu/cpu-cycles/'

The tool will then read the sysfs file, substitute the content to
obtain:

  perf stat -e 'cpu/event=0x3c/'

and run with that.

Within all this, the perf_event_attr::config* field names are hard-coded
special, so 'cpu/config=0xffff/' will always work, even without sysfs
format/ specification and is equivalent to the raw event stuff we had
before.


If the Power PMU lacks any structure to the raw config, you could simply
provide sysfs event/ files with:

  config=0xdeadbeef

like content.
