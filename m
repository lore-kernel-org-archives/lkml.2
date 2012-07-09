Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2GIKkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:40:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab2GIKkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:40:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,552,1336320000"; 
   d="scan'208";a="5356059"
Message-ID: <4FFAB60F.9040702@cn.fujitsu.com>
Date: Mon, 09 Jul 2012 18:44:31 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 7/7 v6] deal with panicked event accoring to '-machine
 panic_action=action'
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B2E7.2060405@cn.fujitsu.com> <4FF6C77B.208@siemens.com>
In-Reply-To: <4FF6C77B.208@siemens.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/09 18:39:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/09 18:39:55,
	Serialize complete at 2012/07/09 18:39:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/06/2012 07:09 PM, Jan Kiszka Wrote:
> On 2012-07-06 11:41, Wen Congyang wrote:
>> The action is the same as -onpanic parameter.
> 
> As explained in patch 5, now that we have a related device, this no
> longer needs to be a machine property.
> 
> Would could be a machine property is enabling/disabling this device.
> That's probably useful as it uses a fixed PIO port that might conflict
> with (non-Linux) guest expectations and/or future device models.

Yes, it is very useful. I will do it.

Thanks
Wen Congyang

> 
> Jan
> 
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  qemu-config.c   |    4 ++++
>>  qemu-options.hx |    4 +++-
>>  vl.c            |    7 +++++++
>>  3 files changed, 14 insertions(+), 1 deletions(-)
>>
>> diff --git a/qemu-config.c b/qemu-config.c
>> index 5c3296b..805e7c4 100644
>> --- a/qemu-config.c
>> +++ b/qemu-config.c
>> @@ -595,6 +595,10 @@ static QemuOptsList qemu_machine_opts = {
>>              .name = "dt_compatible",
>>              .type = QEMU_OPT_STRING,
>>              .help = "Overrides the \"compatible\" property of the dt root node",
>> +        }, {
>> +            .name = "panic_action",
>> +            .type = QEMU_OPT_STRING,
>> +            .help = "The action what QEMU will do when the guest is panicked",
>>          },
>>          { /* End of list */ }
>>      },
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index 4a061bf..083a21d 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -33,7 +33,9 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>>      "                property accel=accel1[:accel2[:...]] selects accelerator\n"
>>      "                supported accelerators are kvm, xen, tcg (default: tcg)\n"
>>      "                kernel_irqchip=on|off controls accelerated irqchip support\n"
>> -    "                kvm_shadow_mem=size of KVM shadow MMU\n",
>> +    "                kvm_shadow_mem=size of KVM shadow MMU\n"
>> +    "                panic_action=none|pause|poweroff|reset controls what QEmu\n"
>> +    "                will do when the guest is panicked",
>>      QEMU_ARCH_ALL)
>>  STEXI
>>  @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
>> diff --git a/vl.c b/vl.c
>> index 1a68257..091c43b 100644
>> --- a/vl.c
>> +++ b/vl.c
>> @@ -2301,6 +2301,7 @@ int main(int argc, char **argv, char **envp)
>>      };
>>      const char *trace_events = NULL;
>>      const char *trace_file = NULL;
>> +    const char *panic_action = NULL;
>>  
>>      atexit(qemu_run_exit_notifiers);
>>      error_set_progname(argv[0]);
>> @@ -3372,10 +3373,16 @@ int main(int argc, char **argv, char **envp)
>>          kernel_filename = qemu_opt_get(machine_opts, "kernel");
>>          initrd_filename = qemu_opt_get(machine_opts, "initrd");
>>          kernel_cmdline = qemu_opt_get(machine_opts, "append");
>> +        panic_action = qemu_opt_get(machine_opts, "panic_action");
>>      } else {
>>          kernel_filename = initrd_filename = kernel_cmdline = NULL;
>>      }
>>  
>> +    if (panic_action && select_panicked_action(panic_action) == -1) {
>> +        fprintf(stderr, "Unknown -panic_action parameter\n");
>> +        exit(1);
>> +    }
>> +
>>      if (!kernel_cmdline) {
>>          kernel_cmdline = "";
>>      }
>>
> 

