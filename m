Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2IVHE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 03:04:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58783 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2IVHEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 03:04:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVQJQfBZn7AH4M5hibx=iNa9RbfSaBdb35FWxDiRXHvrA@mail.gmail.com>
References: <20120922003557.GF5959@localhost>
	<CAE9FiQVQJQfBZn7AH4M5hibx=iNa9RbfSaBdb35FWxDiRXHvrA@mail.gmail.com>
Date: Sat, 22 Sep 2012 00:04:51 -0700
X-Google-Sender-Auth: 1sBX3G22VSMihPx5y0r38eKw_8o
Message-ID: <CAE9FiQVQMVsqG2vHhyktTtUSJ_dDRpTpwB_x--agMWbm6PHsEg@mail.gmail.com>
Subject: Re: [ACPI/PCI] possible recursive locking detected
From: Yinghai Lu <yinghai@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175884fc0eff9e04ca44f92d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175884fc0eff9e04ca44f92d
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 21, 2012 at 9:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Sep 21, 2012 at 5:35 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> Hi Taku,
>>
>> The below oops is pretty reproducible, and shows up first in:
>>
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/taku-acpi-pci-host-bridge-v3
>> head:   e3faec8ea9c8aa683c56fa20ff2c58a4c5857960
>> commit: d3c663236318a43fed5d86a643e6ea2534e9220e [5/7] PCI/ACPI: Protect acpi_pci_roots list with mutex
>>
>> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
>> [    8.613239]   lock(acpi_pci_root_lock);
>> [    8.613239]   lock(acpi_pci_root_lock);
>> [    8.613239]  #0:  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
>> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
>>
>> [    8.610859]
>> [    8.611385] =============================================
>> [    8.612505] [ INFO: possible recursive locking detected ]
>> [    8.613239] 3.6.0-rc1-00022-gd3c6632 #7512 Not tainted
>> [    8.613239] ---------------------------------------------
>> [    8.613239] swapper/0/1 is trying to acquire lock:
>> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]
>> [    8.613239] but task is already holding lock:
>> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
>> [    8.613239]
>> [    8.613239] other info that might help us debug this:
>> [    8.613239]  Possible unsafe locking scenario:
>> [    8.613239]
>> [    8.613239]        CPU0
>> [    8.613239]        ----
>> [    8.613239]   lock(acpi_pci_root_lock);
>> [    8.613239]   lock(acpi_pci_root_lock);
>> [    8.613239]
>> [    8.613239]  *** DEADLOCK ***
>> [    8.613239]
>> [    8.613239]  May be due to missing lock nesting notation
>> [    8.613239]
>> [    8.613239] 1 lock held by swapper/0/1:
>> [    8.613239]  #0:  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
>> [    8.613239]
>> [    8.613239] stack backtrace:
>> [    8.613239] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1-00022-gd3c6632 #7512
>> [    8.613239] Call Trace:
>> [    8.613239]  [<ffffffff810d7ae5>] __lock_acquire+0xbef/0xd04
>> [    8.613239]  [<ffffffff8106e60b>] ? kvm_clock_read+0x2e/0x36
>> [    8.613239]  [<ffffffff810d80a3>] lock_acquire+0xd5/0x119
>> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff8270c01b>] __mutex_lock_common+0x58/0x387
>> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff8106e60b>] ? kvm_clock_read+0x2e/0x36
>> [    8.613239]  [<ffffffff81118ea4>] ? irq_trace+0x14/0x21
>> [    8.613239]  [<ffffffff8270c459>] mutex_lock_nested+0x40/0x45
>> [    8.613239]  [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
>> [    8.613239]  [<ffffffff816beb25>] acpi_pci_get_bridge_handle+0x2c/0x2e
>> [    8.613239]  [<ffffffff816beb3f>] acpi_pci_check_ejectable+0x18/0x49
>> [    8.613239]  [<ffffffff8270ea46>] ? _raw_spin_unlock_irqrestore+0x45/0x61
>> [    8.613239]  [<ffffffff816c6981>] register_slot+0x2f/0x460
>> [    8.613239]  [<ffffffff810afbf8>] ? up+0x39/0x3e
>> [    8.613239]  [<ffffffff81757575>] acpi_ns_walk_namespace+0xbe/0x179
>> [    8.613239]  [<ffffffff8173c09a>] ? acpi_os_wait_semaphore+0x45/0x5a
>> [    8.613239]  [<ffffffff816c6952>] ? kzalloc.constprop.14+0x10/0x10
>> [    8.613239]  [<ffffffff816c6952>] ? kzalloc.constprop.14+0x10/0x10
>> [    8.613239]  [<ffffffff81757a1d>] acpi_walk_namespace+0x98/0xcb
>> [    8.613239]  [<ffffffff816c6dfe>] init_bridge_misc+0x4c/0xd5
>> [    8.613239]  [<ffffffff816c6f70>] add_bridge+0xe9/0x138
>> [    8.613239]  [<ffffffff817423c9>] acpi_pci_register_driver+0x52/0x79
>> [    8.613239]  [<ffffffff838ce2b2>] ? shpcd_init+0xf0/0xf0
>> [    8.613239]  [<ffffffff838ce34a>] acpiphp_glue_init+0x48/0x51
>> [    8.613239]  [<ffffffff838ce2dd>] acpiphp_init+0x2b/0x50
>> [    8.613239]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
>> [    8.613239]  [<ffffffff8389ccef>] kernel_init+0x13c/0x1c0
>> [    8.613239]  [<ffffffff8389c590>] ? do_early_param+0x8c/0x8c
>> [    8.613239]  [<ffffffff82716944>] kernel_thread_helper+0x4/0x10
>> [    8.613239]  [<ffffffff8270ee70>] ? retint_restore_args+0x13/0x13
>> [    8.613239]  [<ffffffff8389cbb3>] ? start_kernel+0x3d1/0x3d1
>> [    8.613239]  [<ffffffff82716940>] ? gs_change+0x13/0x13
>
> Please check attached patch that should fix the problem.

updated more aggressive version. two patches.

-Yinghai

--0015175884fc0eff9e04ca44f92d
Content-Type: application/octet-stream; 
	name="pci_root_bus_to_handle_1.patch"
Content-Disposition: attachment; filename="pci_root_bus_to_handle_1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7edhg7z0

U3ViamVjdDogW1BBVENIXSBQQ0ksIEFDUEk6IFVzZSBwY2lfaG9zdF9icmlkZ2UgZGV2IHRvIHNh
dmUgYWNwaV9oYW5kbGUKClNvIHdlIGNvdWxkIGF2b2lkIGNhbGxpbmcgYWNwaV9nZXRfcGNpX3Jv
b3RicmlkZ2VfaGFuZGxlIHRoYXQgY291bGQgY2F1c2UgZGVhZGxvY2suCgpub24gcm9vdCBwY2kg
YnVzIGlzIHVzaW5nIGJyaWRnZS0+ZGV2IGFyY2hkYXRhLmFjcGlfaGFuZGxlLgpmb3Igcm9vdCBi
dXMgdGhhdCBmaWVsZCBpcyBub3QgdXNlZCwgY291bGQganVzdCBzYXZlIHJvb3QgaGFuZGxlLCBh
bmQgZ2V0IHRoYXQKbGF0ZXIgd2hlbiBuZWVkIHRvIGdldCByb290IGJ1cydzIGhhbmRsZS4KCi12
MjogbW92ZSBzZXR0aW5nIGNvZGUgdG8gcGNpX3Jvb3QuYwoKU2lnbmVkLW9mZi1ieTogWWluZ2hh
aSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgpDYzogTGVuIEJyb3duIDxsZW5iQGtlcm5lbC5vcmc+
CkNjOiBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9yZwoKLS0tCiBkcml2ZXJzL2FjcGkvcGNpX3Jv
b3QuYyAgfCAgIDIxICsrKy0tLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9wY2kvcGNpLWFjcGku
YyAgIHwgICAgNCArKystCiBpbmNsdWRlL2FjcGkvYWNwaV9idXMuaCAgfCAgICAxIC0KIGluY2x1
ZGUvbGludXgvcGNpLWFjcGkuaCB8ICAgMTUgKysrKysrKysrKy0tLS0tCiA0IGZpbGVzIGNoYW5n
ZWQsIDE2IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9p
bmNsdWRlL2xpbnV4L3BjaS1hY3BpLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvaW5j
bHVkZS9saW51eC9wY2ktYWNwaS5oCisrKyBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9wY2ktYWNw
aS5oCkBAIC0yMiwxOSArMjIsMjQgQEAgZXh0ZXJuIHBoeXNfYWRkcl90IGFjcGlfcGNpX3Jvb3Rf
Z2V0X21jZgogc3RhdGljIGlubGluZSBhY3BpX2hhbmRsZSBhY3BpX2ZpbmRfcm9vdF9icmlkZ2Vf
aGFuZGxlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQogewogCXN0cnVjdCBwY2lfYnVzICpwYnVzID0g
cGRldi0+YnVzOworCiAJLyogRmluZCBhIFBDSSByb290IGJ1cyAqLwogCXdoaWxlICghcGNpX2lz
X3Jvb3RfYnVzKHBidXMpKQogCQlwYnVzID0gcGJ1cy0+cGFyZW50OwotCXJldHVybiBhY3BpX2dl
dF9wY2lfcm9vdGJyaWRnZV9oYW5kbGUocGNpX2RvbWFpbl9ucihwYnVzKSwKLQkJCQkJICAgICAg
cGJ1cy0+bnVtYmVyKTsKKworCXJldHVybiBERVZJQ0VfQUNQSV9IQU5ETEUocGJ1cy0+YnJpZGdl
KTsKIH0KIAogc3RhdGljIGlubGluZSBhY3BpX2hhbmRsZSBhY3BpX3BjaV9nZXRfYnJpZGdlX2hh
bmRsZShzdHJ1Y3QgcGNpX2J1cyAqcGJ1cykKIHsKKwlzdHJ1Y3QgZGV2aWNlICpkZXY7CisKIAlp
ZiAoIXBjaV9pc19yb290X2J1cyhwYnVzKSkKLQkJcmV0dXJuIERFVklDRV9BQ1BJX0hBTkRMRSgm
KHBidXMtPnNlbGYtPmRldikpOwotCXJldHVybiBhY3BpX2dldF9wY2lfcm9vdGJyaWRnZV9oYW5k
bGUocGNpX2RvbWFpbl9ucihwYnVzKSwKLQkJCQkJICAgICAgcGJ1cy0+bnVtYmVyKTsKKwkJZGV2
ID0gJnBidXMtPnNlbGYtPmRldjsKKwllbHNlCisJCWRldiA9IHBidXMtPmJyaWRnZTsKKworCXJl
dHVybiBERVZJQ0VfQUNQSV9IQU5ETEUoZGV2KTsKIH0KICNlbmRpZgogCkluZGV4OiBsaW51eC0y
LjYvZHJpdmVycy9hY3BpL3BjaV9yb290LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcv
ZHJpdmVycy9hY3BpL3BjaV9yb290LmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvcGNpX3Jv
b3QuYwpAQCAtNTQyLDYgKzUyNCw5IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IGFjcGlfcGNpX3Jv
b3RfYWRkKHMKIAkJZ290byBvdXRfZGVsX3Jvb3Q7CiAJfQogCisJLyogdG8gZmluZCBoYW5kbGUg
ZnJvbSByb290IGJ1cyAqLworCXJvb3QtPmJ1cy0+YnJpZGdlLT5hcmNoZGF0YS5hY3BpX2hhbmRs
ZSA9IGRldmljZS0+aGFuZGxlOworCiAJLyoKIAkgKiBBdHRhY2ggQUNQSS1QQ0kgQ29udGV4dAog
CSAqIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCg==
--0015175884fc0eff9e04ca44f92d
Content-Type: application/octet-stream; 
	name="pci_root_bus_to_handle_2.patch"
Content-Disposition: attachment; filename="pci_root_bus_to_handle_2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7edhqzu1

U3ViamVjdDogW1BBVENIXSBQQ0ksIEFDUEk6IGtpbGwgYWNwaV9nZXRfcGNpX3Jvb3RicmlkZ2Vf
aGFuZGxlCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CkNj
OiBMZW4gQnJvd24gPGxlbmJAa2VybmVsLm9yZz4KQ2M6IGxpbnV4LWFjcGlAdmdlci5rZXJuZWwu
b3JnCgotLS0KIGRyaXZlcnMvYWNwaS9wY2lfcm9vdC5jICB8ICAgMjEgKysrLS0tLS0tLS0tLS0t
LS0tLS0tCiBkcml2ZXJzL3BjaS9wY2ktYWNwaS5jICAgfCAgICA0ICsrKy0KIGluY2x1ZGUvYWNw
aS9hY3BpX2J1cy5oICB8ICAgIDEgLQogaW5jbHVkZS9saW51eC9wY2ktYWNwaS5oIHwgICAxNSAr
KysrKysrKysrLS0tLS0KIDQgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMjUgZGVs
ZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvYWNwaS9wY2lfcm9vdC5jCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvYWNwaS9wY2lfcm9vdC5jCisrKyBsaW51
eC0yLjYvZHJpdmVycy9hY3BpL3BjaV9yb290LmMKQEAgLTExMCwyNCArMTEwLDYgQEAgdm9pZCBh
Y3BpX3BjaV91bnJlZ2lzdGVyX2RyaXZlcihzdHJ1Y3QgYQogfQogRVhQT1JUX1NZTUJPTChhY3Bp
X3BjaV91bnJlZ2lzdGVyX2RyaXZlcik7CiAKLWFjcGlfaGFuZGxlIGFjcGlfZ2V0X3BjaV9yb290
YnJpZGdlX2hhbmRsZSh1bnNpZ25lZCBpbnQgc2VnLCB1bnNpZ25lZCBpbnQgYnVzKQotewotCXN0
cnVjdCBhY3BpX3BjaV9yb290ICpyb290OwotCWFjcGlfaGFuZGxlIGhhbmRsZSA9IE5VTEw7Ci0J
Ci0JbXV0ZXhfbG9jaygmYWNwaV9wY2lfcm9vdF9sb2NrKTsKLQlsaXN0X2Zvcl9lYWNoX2VudHJ5
KHJvb3QsICZhY3BpX3BjaV9yb290cywgbm9kZSkKLQkJaWYgKChyb290LT5zZWdtZW50ID09ICh1
MTYpIHNlZykgJiYKLQkJICAgIChyb290LT5zZWNvbmRhcnkuc3RhcnQgPT0gKHUxNikgYnVzKSkg
ewotCQkJaGFuZGxlID0gcm9vdC0+ZGV2aWNlLT5oYW5kbGU7Ci0JCQlicmVhazsKLQkJfQotCW11
dGV4X3VubG9jaygmYWNwaV9wY2lfcm9vdF9sb2NrKTsKLQlyZXR1cm4gaGFuZGxlOwotfQotCi1F
WFBPUlRfU1lNQk9MX0dQTChhY3BpX2dldF9wY2lfcm9vdGJyaWRnZV9oYW5kbGUpOwotCiAvKioK
ICAqIGFjcGlfaXNfcm9vdF9icmlkZ2UgLSBkZXRlcm1pbmUgd2hldGhlciBhbiBBQ1BJIENBIG5v
ZGUgaXMgYSBQQ0kgcm9vdCBicmlkZ2UKICAqIEBoYW5kbGUgLSB0aGUgQUNQSSBDQSBub2RlIGlu
IHF1ZXN0aW9uLgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS1hY3BpLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvcGNpLWFjcGkuYworKysgbGludXgt
Mi42L2RyaXZlcnMvcGNpL3BjaS1hY3BpLmMKQEAgLTM3Miw5ICszNzIsMTEgQEAgc3RhdGljIGlu
dCBhY3BpX3BjaV9maW5kX3Jvb3RfYnJpZGdlKHN0cgogCW51bSA9IHNzY2FuZihkZXZfbmFtZShk
ZXYpLCAicGNpJTA0eDolMDJ4IiwgJnNlZywgJmJ1cyk7CiAJaWYgKG51bSAhPSAyKQogCQlyZXR1
cm4gLUVOT0RFVjsKLQkqaGFuZGxlID0gYWNwaV9nZXRfcGNpX3Jvb3RicmlkZ2VfaGFuZGxlKHNl
ZywgYnVzKTsKKworCSpoYW5kbGUgPSBERVZJQ0VfQUNQSV9IQU5ETEUoZGV2KTsKIAlpZiAoISpo
YW5kbGUpCiAJCXJldHVybiAtRU5PREVWOworCiAJcmV0dXJuIDA7CiB9CiAKSW5kZXg6IGxpbnV4
LTIuNi9pbmNsdWRlL2FjcGkvYWNwaV9idXMuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9pbmNsdWRlL2FjcGkvYWNwaV9idXMuaAorKysgbGludXgtMi42L2luY2x1ZGUvYWNwaS9hY3Bp
X2J1cy5oCkBAIC00MTMsNyArNDEzLDYgQEAgc3RydWN0IGFjcGlfcGNpX3Jvb3QgewogLyogaGVs
cGVyICovCiBhY3BpX2hhbmRsZSBhY3BpX2dldF9jaGlsZChhY3BpX2hhbmRsZSwgdTY0KTsKIGlu
dCBhY3BpX2lzX3Jvb3RfYnJpZGdlKGFjcGlfaGFuZGxlKTsKLWFjcGlfaGFuZGxlIGFjcGlfZ2V0
X3BjaV9yb290YnJpZGdlX2hhbmRsZSh1bnNpZ25lZCBpbnQsIHVuc2lnbmVkIGludCk7CiBzdHJ1
Y3QgYWNwaV9wY2lfcm9vdCAqYWNwaV9wY2lfZmluZF9yb290KGFjcGlfaGFuZGxlIGhhbmRsZSk7
CiAjZGVmaW5lIERFVklDRV9BQ1BJX0hBTkRMRShkZXYpICgoYWNwaV9oYW5kbGUpKChkZXYpLT5h
cmNoZGF0YS5hY3BpX2hhbmRsZSkpCiAK
--0015175884fc0eff9e04ca44f92d--
