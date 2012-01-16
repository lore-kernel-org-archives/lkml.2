Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2APKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:08:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46607 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab2APKIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:08:41 -0500
MIME-Version: 1.0
In-Reply-To: <4F13EEC5.8050807@linux.vnet.ibm.com>
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
	<4F13EEC5.8050807@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 10:08:40 +0000
Message-ID: <CAJSP0QVxR9sYYh_Vr6ZKAU-YrWpjgL5jpiKz2zt7eJxV_kgaOg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 9:32 AM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> +DESCRIPTION
> +-----------
> +You can analyze some crucial events and statistics with this
> +'perf kvm-events' command.

This line is very general and does not explain which events/statistics
can be collected or how you can use that information.  I suggest
making this description more specific.  Explain that this subcommand
observers kvm.ko tracepoints and annotates/decodes them with
additional information (this is why I would use this command and not
raw perf record -e kvm:\*).

> +       { SVM_EXIT_MONITOR,                     "monitor" }, \
> +       { SVM_EXIT_MWAIT,                       "mwait" }, \
> +       { SVM_EXIT_XSETBV,                      "xsetbv" }, \
> +       { SVM_EXIT_NPF,                         "npf" }

All this copy-paste could be avoided by sharing this stuff with the
arch/x86/kvm/ code.

> +static void exit_event_decode_key(struct event_key *key, char decode[20])
> +{
> +       const char *exit_reason = get_exit_reason(key->info, key->key);
> +
> +       memset(decode, 0, 20);
> +       strncpy(decode, exit_reason, 20);

This is a bad pattern to follow when using strncpy(3) because if there
was a strlen(exit_reason) == 20 string then decode[] would not be
NUL-terminated.  Right now it's safe but it's better to just use
strlcpy() and drop the memset(3).

> +}
> +
> +static struct kvm_events_ops exit_events = {
> +       .is_begain_event = exit_event_begain,
> +       .is_end_event = exit_event_end,
> +       .get_key = exit_event_get_key,
> +       .decode_key = exit_event_decode_key,
> +       .name = "VM-EXIT"
> +};
> +
> +#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
> +#define KVM_TRACE_MMIO_READ 1
> +#define KVM_TRACE_MMIO_WRITE 2
> +static bool mmio_event_begain(struct event *event, void *data)
> +{
> +       if (!strcmp(event->name, "kvm_mmio")) {
> +               long type = raw_field_value(event, "type", data);
> +
> +               if (type != KVM_TRACE_MMIO_READ_UNSATISFIED)
> +                       return true;
> +       };
> +
> +       return false;
> +}
> +
> +static bool mmio_event_end(struct event *event)
> +{
> +       return !strcmp(event->name, "kvm_mmio_done");
> +}
> +
> +static struct event_key mmio_event_get_key(struct event *event, void *data)
> +{
> +       struct event_key key;
> +
> +       key.key = raw_field_value(event, "gpa", data);
> +       key.info = raw_field_value(event, "type", data);
> +
> +       return key;
> +}
> +
> +static void mmio_event_decode_key(struct event_key *key, char decode[20])
> +{
> +       memset(decode, 0, 20);
> +       sprintf(decode, "%#lx:%s", key->key,
> +               key->info == KVM_TRACE_MMIO_READ ? "R" : "W");

Please drop the memset and use snprintf(3) instead of sprintf(3).  It
places the NUL-terminator and ensures you don't exceed the buffer
size.

Same pattern below.
