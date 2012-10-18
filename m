Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2JRSW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:22:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59998 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2JRSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 18 Oct 2012 11:22:05 -0700
Message-ID: <CAK5ve-KwAJh0NukVqCWotzh8uhA-nNhzNgsstKxTQpQsh5S1ww@mail.gmail.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>
Cc: akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b621ee211c83704cc597814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b621ee211c83704cc597814
Content-Type: text/plain; charset=ISO-8859-1

So sorry about the delay, since I'm moving and don't have network
connection for several weeks. Right now have to use web interface of
GMAIL to send out this patch, if it was corrupted by GMAIL, please use
the attached patch file. Sorry about this.

Thanks,
-Bryan

On Thu, Oct 18, 2012 at 11:18 AM, Bryan Wu <cooloney@gmail.com> wrote:
> Mutex lock is not safe in atomic context like the bug reported by
> Miles Lane:
>
> ---
> ACPI: Preparing to enter system sleep state S3
> PM: Saving platform NVS memory
> Disabling non-boot CPUs ...
> numa_remove_cpu cpu 1 node 0: mask now 0
> Broke affinity for irq 46
> smpboot: CPU 1 is now offline
> BUG: sleeping function called from invalid context at kernel/mutex.c:269
> in_atomic(): 0, irqs_disabled(): 1, pid: 3561, name: pm-suspend
> 4 locks held by pm-suspend/3561:
>  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8113cab6>]
> sysfs_write_file+0x37/0x121
>  #1:  (s_active#98){.+.+.+}, at: [<ffffffff8113cb50>]
> sysfs_write_file+0xd1/0x121
>  #2:  (autosleep_lock){+.+.+.}, at: [<ffffffff810616c2>]
> pm_autosleep_lock+0x12/0x14
>  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff8105c06c>] pm_suspend+0x38/0x1b8
> irq event stamp: 103458
> hardirqs last  enabled at (103457): [<ffffffff81460461>]
> __mutex_unlock_slowpath+0x101/0x125
> hardirqs last disabled at (103458): [<ffffffff8105be25>]
> arch_suspend_disable_irqs+0xa/0xc
> softirqs last  enabled at (103196): [<ffffffff8103445d>]
> __do_softirq+0x12a/0x155
> softirqs last disabled at (103171): [<ffffffff8146836c>] call_softirq+0x1c/0x30
> Pid: 3561, comm: pm-suspend Not tainted 3.6.0+ #26
> Call Trace:
>  [<ffffffff8106b64e>] ? print_irqtrace_events+0x9d/0xa1
>  [<ffffffff8104efcd>] __might_sleep+0x19f/0x1a8
>  [<ffffffff81460345>] mutex_lock_nested+0x20/0x3b
>  [<ffffffff81391cbb>] ledtrig_cpu+0x3b/0x7b
>  [<ffffffff81391d29>] ledtrig_cpu_syscore_suspend+0xe/0x15
>  [<ffffffff813329e9>] syscore_suspend+0x78/0xfd
>  [<ffffffff8105bf42>] suspend_devices_and_enter+0x10f/0x201
>  [<ffffffff8105c133>] pm_suspend+0xff/0x1b8
>  [<ffffffff8105b4fa>] state_store+0x43/0x6c
>  [<ffffffff811c5ba6>] kobj_attr_store+0xf/0x1b
>  [<ffffffff8113cb68>] sysfs_write_file+0xe9/0x121
>  [<ffffffff810e48a3>] vfs_write+0x9b/0xfd
>  [<ffffffff8106bc63>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff810e4ac6>] sys_write+0x4d/0x7a
>  [<ffffffff814672f4>] tracesys+0xdd/0xe2
> ---
>
> This patch replace mutex lock with spin lock which is safe for this case.
>
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bryan Wu <cooloney@gmail.com>
> ---
>  drivers/leds/ledtrig-cpu.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
> index b312056..9e78018 100644
> --- a/drivers/leds/ledtrig-cpu.c
> +++ b/drivers/leds/ledtrig-cpu.c
> @@ -25,7 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/percpu.h>
>  #include <linux/syscore_ops.h>
> -#include <linux/rwsem.h>
> +#include <linux/spinlock.h>
>  #include "leds.h"
>
>  #define MAX_NAME_LEN   8
> @@ -33,7 +33,7 @@
>  struct led_trigger_cpu {
>         char name[MAX_NAME_LEN];
>         struct led_trigger *_trig;
> -       struct mutex lock;
> +       spinlock_t lock;
>         int lock_is_inited;
>  };
>
> @@ -50,11 +50,11 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
>  {
>         struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
>
> -       /* mutex lock should be initialized before calling mutex_call() */
> +       /* spin lock should be initialized before calling spinlock calls */
>         if (!trig->lock_is_inited)
>                 return;
>
> -       mutex_lock(&trig->lock);
> +       spin_lock(&trig->lock);
>
>         /* Locate the correct CPU LED */
>         switch (ledevt) {
> @@ -76,7 +76,7 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
>                 break;
>         }
>
> -       mutex_unlock(&trig->lock);
> +       spin_unlock(&trig->lock);
>  }
>  EXPORT_SYMBOL(ledtrig_cpu);
>
> @@ -117,14 +117,14 @@ static int __init ledtrig_cpu_init(void)
>         for_each_possible_cpu(cpu) {
>                 struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
>
> -               mutex_init(&trig->lock);
> +               spin_lock_init(&trig->lock);
>
>                 snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
>
> -               mutex_lock(&trig->lock);
> +               spin_lock(&trig->lock);
>                 led_trigger_register_simple(trig->name, &trig->_trig);
>                 trig->lock_is_inited = 1;
> -               mutex_unlock(&trig->lock);
> +               spin_unlock(&trig->lock);
>         }
>
>         register_syscore_ops(&ledtrig_cpu_syscore_ops);
> @@ -142,15 +142,14 @@ static void __exit ledtrig_cpu_exit(void)
>         for_each_possible_cpu(cpu) {
>                 struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
>
> -               mutex_lock(&trig->lock);
> +               spin_lock(&trig->lock);
>
>                 led_trigger_unregister_simple(trig->_trig);
>                 trig->_trig = NULL;
>                 memset(trig->name, 0, MAX_NAME_LEN);
>                 trig->lock_is_inited = 0;
>
> -               mutex_unlock(&trig->lock);
> -               mutex_destroy(&trig->lock);
> +               spin_unlock(&trig->lock);
>         }
>
>         unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
> --
> 1.7.9.5

--047d7b621ee211c83704cc597814
Content-Type: application/octet-stream; 
	name="0001-ledtrig-cpu-use-spin_lock-to-replace-mutex-lock.patch"
Content-Disposition: attachment; 
	filename="0001-ledtrig-cpu-use-spin_lock-to-replace-mutex-lock.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8g75go50

RnJvbSA2MzlmNTQxODY0MDNhYWZjYjNiMzMxOWE4ZjYxZTRiMDZjMjVlZWVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCcnlhbiBXdSA8Y29vbG9uZXlAZ21haWwuY29tPgpEYXRlOiBU
aHUsIDE4IE9jdCAyMDEyIDA5OjU0OjI0IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gbGVkdHJpZy1j
cHU6IHVzZSBzcGluX2xvY2sgdG8gcmVwbGFjZSBtdXRleCBsb2NrCgpNdXRleCBsb2NrIGlzIG5v
dCBzYWZlIGluIGF0b21pYyBjb250ZXh0IGxpa2UgdGhlIGJ1ZyByZXBvcnRlZCBieQpNaWxlcyBM
YW5lOgoKLS0tCkFDUEk6IFByZXBhcmluZyB0byBlbnRlciBzeXN0ZW0gc2xlZXAgc3RhdGUgUzMK
UE06IFNhdmluZyBwbGF0Zm9ybSBOVlMgbWVtb3J5CkRpc2FibGluZyBub24tYm9vdCBDUFVzIC4u
LgpudW1hX3JlbW92ZV9jcHUgY3B1IDEgbm9kZSAwOiBtYXNrIG5vdyAwCkJyb2tlIGFmZmluaXR5
IGZvciBpcnEgNDYKc21wYm9vdDogQ1BVIDEgaXMgbm93IG9mZmxpbmUKQlVHOiBzbGVlcGluZyBm
dW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQga2VybmVsL211dGV4LmM6MjY5
CmluX2F0b21pYygpOiAwLCBpcnFzX2Rpc2FibGVkKCk6IDEsIHBpZDogMzU2MSwgbmFtZTogcG0t
c3VzcGVuZAo0IGxvY2tzIGhlbGQgYnkgcG0tc3VzcGVuZC8zNTYxOgogIzA6ICAoJmJ1ZmZlci0+
bXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODExM2NhYjY+XQpzeXNmc193cml0ZV9maWxl
KzB4MzcvMHgxMjEKICMxOiAgKHNfYWN0aXZlIzk4KXsuKy4rLit9LCBhdDogWzxmZmZmZmZmZjgx
MTNjYjUwPl0Kc3lzZnNfd3JpdGVfZmlsZSsweGQxLzB4MTIxCiAjMjogIChhdXRvc2xlZXBfbG9j
ayl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4MTA2MTZjMj5dCnBtX2F1dG9zbGVlcF9sb2NrKzB4
MTIvMHgxNAogIzM6ICAocG1fbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODEwNWMwNmM+
XSBwbV9zdXNwZW5kKzB4MzgvMHgxYjgKaXJxIGV2ZW50IHN0YW1wOiAxMDM0NTgKaGFyZGlycXMg
bGFzdCAgZW5hYmxlZCBhdCAoMTAzNDU3KTogWzxmZmZmZmZmZjgxNDYwNDYxPl0KX19tdXRleF91
bmxvY2tfc2xvd3BhdGgrMHgxMDEvMHgxMjUKaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMTAz
NDU4KTogWzxmZmZmZmZmZjgxMDViZTI1Pl0KYXJjaF9zdXNwZW5kX2Rpc2FibGVfaXJxcysweGEv
MHhjCnNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDEwMzE5Nik6IFs8ZmZmZmZmZmY4MTAzNDQ1
ZD5dCl9fZG9fc29mdGlycSsweDEyYS8weDE1NQpzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgx
MDMxNzEpOiBbPGZmZmZmZmZmODE0NjgzNmM+XSBjYWxsX3NvZnRpcnErMHgxYy8weDMwClBpZDog
MzU2MSwgY29tbTogcG0tc3VzcGVuZCBOb3QgdGFpbnRlZCAzLjYuMCsgIzI2CkNhbGwgVHJhY2U6
CiBbPGZmZmZmZmZmODEwNmI2NGU+XSA/IHByaW50X2lycXRyYWNlX2V2ZW50cysweDlkLzB4YTEK
IFs8ZmZmZmZmZmY4MTA0ZWZjZD5dIF9fbWlnaHRfc2xlZXArMHgxOWYvMHgxYTgKIFs8ZmZmZmZm
ZmY4MTQ2MDM0NT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4MjAvMHgzYgogWzxmZmZmZmZmZjgxMzkx
Y2JiPl0gbGVkdHJpZ19jcHUrMHgzYi8weDdiCiBbPGZmZmZmZmZmODEzOTFkMjk+XSBsZWR0cmln
X2NwdV9zeXNjb3JlX3N1c3BlbmQrMHhlLzB4MTUKIFs8ZmZmZmZmZmY4MTMzMjllOT5dIHN5c2Nv
cmVfc3VzcGVuZCsweDc4LzB4ZmQKIFs8ZmZmZmZmZmY4MTA1YmY0Mj5dIHN1c3BlbmRfZGV2aWNl
c19hbmRfZW50ZXIrMHgxMGYvMHgyMDEKIFs8ZmZmZmZmZmY4MTA1YzEzMz5dIHBtX3N1c3BlbmQr
MHhmZi8weDFiOAogWzxmZmZmZmZmZjgxMDViNGZhPl0gc3RhdGVfc3RvcmUrMHg0My8weDZjCiBb
PGZmZmZmZmZmODExYzViYTY+XSBrb2JqX2F0dHJfc3RvcmUrMHhmLzB4MWIKIFs8ZmZmZmZmZmY4
MTEzY2I2OD5dIHN5c2ZzX3dyaXRlX2ZpbGUrMHhlOS8weDEyMQogWzxmZmZmZmZmZjgxMGU0OGEz
Pl0gdmZzX3dyaXRlKzB4OWIvMHhmZAogWzxmZmZmZmZmZjgxMDZiYzYzPl0gPyB0cmFjZV9oYXJk
aXJxc19vbisweGQvMHhmCiBbPGZmZmZmZmZmODEwZTRhYzY+XSBzeXNfd3JpdGUrMHg0ZC8weDdh
CiBbPGZmZmZmZmZmODE0NjcyZjQ+XSB0cmFjZXN5cysweGRkLzB4ZTIKLS0tCgpUaGlzIHBhdGNo
IHJlcGxhY2UgbXV0ZXggbG9jayB3aXRoIHNwaW4gbG9jayB3aGljaCBpcyBzYWZlIGZvciB0aGlz
IGNhc2UuCgpSZXBvcnRlZC1ieTogTWlsZXMgTGFuZSA8bWlsZXMubGFuZUBnbWFpbC5jb20+ClJl
cG9ydGVkLWJ5OiBSYWZhZWwgSi4gV3lzb2NraSA8cmp3QHNpc2sucGw+CkNjOiBMaW51cyBXYWxs
ZWlqIDxsaW51cy53YWxsZWlqQGxpbmFyby5vcmc+ClNpZ25lZC1vZmYtYnk6IEJyeWFuIFd1IDxj
b29sb25leUBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9sZWRzL2xlZHRyaWctY3B1LmMgfCAgIDIx
ICsrKysrKysrKystLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyks
IDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbGVkcy9sZWR0cmlnLWNwdS5j
IGIvZHJpdmVycy9sZWRzL2xlZHRyaWctY3B1LmMKaW5kZXggYjMxMjA1Ni4uOWU3ODAxOCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9sZWRzL2xlZHRyaWctY3B1LmMKKysrIGIvZHJpdmVycy9sZWRzL2xl
ZHRyaWctY3B1LmMKQEAgLTI1LDcgKzI1LDcgQEAKICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiAj
aW5jbHVkZSA8bGludXgvcGVyY3B1Lmg+CiAjaW5jbHVkZSA8bGludXgvc3lzY29yZV9vcHMuaD4K
LSNpbmNsdWRlIDxsaW51eC9yd3NlbS5oPgorI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+CiAj
aW5jbHVkZSAibGVkcy5oIgogCiAjZGVmaW5lIE1BWF9OQU1FX0xFTgk4CkBAIC0zMyw3ICszMyw3
IEBACiBzdHJ1Y3QgbGVkX3RyaWdnZXJfY3B1IHsKIAljaGFyIG5hbWVbTUFYX05BTUVfTEVOXTsK
IAlzdHJ1Y3QgbGVkX3RyaWdnZXIgKl90cmlnOwotCXN0cnVjdCBtdXRleCBsb2NrOworCXNwaW5s
b2NrX3QgbG9jazsKIAlpbnQgbG9ja19pc19pbml0ZWQ7CiB9OwogCkBAIC01MCwxMSArNTAsMTEg
QEAgdm9pZCBsZWR0cmlnX2NwdShlbnVtIGNwdV9sZWRfZXZlbnQgbGVkZXZ0KQogewogCXN0cnVj
dCBsZWRfdHJpZ2dlcl9jcHUgKnRyaWcgPSAmX19nZXRfY3B1X3ZhcihjcHVfdHJpZyk7CiAKLQkv
KiBtdXRleCBsb2NrIHNob3VsZCBiZSBpbml0aWFsaXplZCBiZWZvcmUgY2FsbGluZyBtdXRleF9j
YWxsKCkgKi8KKwkvKiBzcGluIGxvY2sgc2hvdWxkIGJlIGluaXRpYWxpemVkIGJlZm9yZSBjYWxs
aW5nIHNwaW5sb2NrIGNhbGxzICovCiAJaWYgKCF0cmlnLT5sb2NrX2lzX2luaXRlZCkKIAkJcmV0
dXJuOwogCi0JbXV0ZXhfbG9jaygmdHJpZy0+bG9jayk7CisJc3Bpbl9sb2NrKCZ0cmlnLT5sb2Nr
KTsKIAogCS8qIExvY2F0ZSB0aGUgY29ycmVjdCBDUFUgTEVEICovCiAJc3dpdGNoIChsZWRldnQp
IHsKQEAgLTc2LDcgKzc2LDcgQEAgdm9pZCBsZWR0cmlnX2NwdShlbnVtIGNwdV9sZWRfZXZlbnQg
bGVkZXZ0KQogCQlicmVhazsKIAl9CiAKLQltdXRleF91bmxvY2soJnRyaWctPmxvY2spOworCXNw
aW5fdW5sb2NrKCZ0cmlnLT5sb2NrKTsKIH0KIEVYUE9SVF9TWU1CT0wobGVkdHJpZ19jcHUpOwog
CkBAIC0xMTcsMTQgKzExNywxNCBAQCBzdGF0aWMgaW50IF9faW5pdCBsZWR0cmlnX2NwdV9pbml0
KHZvaWQpCiAJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgewogCQlzdHJ1Y3QgbGVkX3RyaWdn
ZXJfY3B1ICp0cmlnID0gJnBlcl9jcHUoY3B1X3RyaWcsIGNwdSk7CiAKLQkJbXV0ZXhfaW5pdCgm
dHJpZy0+bG9jayk7CisJCXNwaW5fbG9ja19pbml0KCZ0cmlnLT5sb2NrKTsKIAogCQlzbnByaW50
Zih0cmlnLT5uYW1lLCBNQVhfTkFNRV9MRU4sICJjcHUlZCIsIGNwdSk7CiAKLQkJbXV0ZXhfbG9j
aygmdHJpZy0+bG9jayk7CisJCXNwaW5fbG9jaygmdHJpZy0+bG9jayk7CiAJCWxlZF90cmlnZ2Vy
X3JlZ2lzdGVyX3NpbXBsZSh0cmlnLT5uYW1lLCAmdHJpZy0+X3RyaWcpOwogCQl0cmlnLT5sb2Nr
X2lzX2luaXRlZCA9IDE7Ci0JCW11dGV4X3VubG9jaygmdHJpZy0+bG9jayk7CisJCXNwaW5fdW5s
b2NrKCZ0cmlnLT5sb2NrKTsKIAl9CiAKIAlyZWdpc3Rlcl9zeXNjb3JlX29wcygmbGVkdHJpZ19j
cHVfc3lzY29yZV9vcHMpOwpAQCAtMTQyLDE1ICsxNDIsMTQgQEAgc3RhdGljIHZvaWQgX19leGl0
IGxlZHRyaWdfY3B1X2V4aXQodm9pZCkKIAlmb3JfZWFjaF9wb3NzaWJsZV9jcHUoY3B1KSB7CiAJ
CXN0cnVjdCBsZWRfdHJpZ2dlcl9jcHUgKnRyaWcgPSAmcGVyX2NwdShjcHVfdHJpZywgY3B1KTsK
IAotCQltdXRleF9sb2NrKCZ0cmlnLT5sb2NrKTsKKwkJc3Bpbl9sb2NrKCZ0cmlnLT5sb2NrKTsK
IAogCQlsZWRfdHJpZ2dlcl91bnJlZ2lzdGVyX3NpbXBsZSh0cmlnLT5fdHJpZyk7CiAJCXRyaWct
Pl90cmlnID0gTlVMTDsKIAkJbWVtc2V0KHRyaWctPm5hbWUsIDAsIE1BWF9OQU1FX0xFTik7CiAJ
CXRyaWctPmxvY2tfaXNfaW5pdGVkID0gMDsKIAotCQltdXRleF91bmxvY2soJnRyaWctPmxvY2sp
OwotCQltdXRleF9kZXN0cm95KCZ0cmlnLT5sb2NrKTsKKwkJc3Bpbl91bmxvY2soJnRyaWctPmxv
Y2spOwogCX0KIAogCXVucmVnaXN0ZXJfc3lzY29yZV9vcHMoJmxlZHRyaWdfY3B1X3N5c2NvcmVf
b3BzKTsKLS0gCjEuNy45LjUKCg==
--047d7b621ee211c83704cc597814--
