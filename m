Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2IVExq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 00:53:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38695 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2IVExo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 00:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120922003557.GF5959@localhost>
References: <20120922003557.GF5959@localhost>
Date: Fri, 21 Sep 2012 21:53:42 -0700
X-Google-Sender-Auth: tSqbwvPPmhTnB9RgtpKR42wLECY
Message-ID: <CAE9FiQVQJQfBZn7AH4M5hibx=iNa9RbfSaBdb35FWxDiRXHvrA@mail.gmail.com>
Subject: Re: [ACPI/PCI] possible recursive locking detected
From: Yinghai Lu <yinghai@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015175cd8620bfcb004ca432405
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175cd8620bfcb004ca432405
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 21, 2012 at 5:35 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Taku,
>
> The below oops is pretty reproducible, and shows up first in:
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/taku-acpi-pci-host-bridge-v3
> head:   e3faec8ea9c8aa683c56fa20ff2c58a4c5857960
> commit: d3c663236318a43fed5d86a643e6ea2534e9220e [5/7] PCI/ACPI: Protect acpi_pci_roots list with mutex
>
> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> [    8.613239]   lock(acpi_pci_root_lock);
> [    8.613239]   lock(acpi_pci_root_lock);
> [    8.613239]  #0:  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
>
> [    8.610859]
> [    8.611385] =============================================
> [    8.612505] [ INFO: possible recursive locking detected ]
> [    8.613239] 3.6.0-rc1-00022-gd3c6632 #7512 Not tainted
> [    8.613239] ---------------------------------------------
> [    8.613239] swapper/0/1 is trying to acquire lock:
> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]
> [    8.613239] but task is already holding lock:
> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> [    8.613239]
> [    8.613239] other info that might help us debug this:
> [    8.613239]  Possible unsafe locking scenario:
> [    8.613239]
> [    8.613239]        CPU0
> [    8.613239]        ----
> [    8.613239]   lock(acpi_pci_root_lock);
> [    8.613239]   lock(acpi_pci_root_lock);
> [    8.613239]
> [    8.613239]  *** DEADLOCK ***
> [    8.613239]
> [    8.613239]  May be due to missing lock nesting notation
> [    8.613239]
> [    8.613239] 1 lock held by swapper/0/1:
> [    8.613239]  #0:  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> [    8.613239]
> [    8.613239] stack backtrace:
> [    8.613239] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1-00022-gd3c6632 #7512
> [    8.613239] Call Trace:
> [    8.613239]  [<ffffffff810d7ae5>] __lock_acquire+0xbef/0xd04
> [    8.613239]  [<ffffffff8106e60b>] ? kvm_clock_read+0x2e/0x36
> [    8.613239]  [<ffffffff810d80a3>] lock_acquire+0xd5/0x119
> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff8270c01b>] __mutex_lock_common+0x58/0x387
> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff8106e60b>] ? kvm_clock_read+0x2e/0x36
> [    8.613239]  [<ffffffff81118ea4>] ? irq_trace+0x14/0x21
> [    8.613239]  [<ffffffff8270c459>] mutex_lock_nested+0x40/0x45
> [    8.613239]  [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> [    8.613239]  [<ffffffff816beb25>] acpi_pci_get_bridge_handle+0x2c/0x2e
> [    8.613239]  [<ffffffff816beb3f>] acpi_pci_check_ejectable+0x18/0x49
> [    8.613239]  [<ffffffff8270ea46>] ? _raw_spin_unlock_irqrestore+0x45/0x61
> [    8.613239]  [<ffffffff816c6981>] register_slot+0x2f/0x460
> [    8.613239]  [<ffffffff810afbf8>] ? up+0x39/0x3e
> [    8.613239]  [<ffffffff81757575>] acpi_ns_walk_namespace+0xbe/0x179
> [    8.613239]  [<ffffffff8173c09a>] ? acpi_os_wait_semaphore+0x45/0x5a
> [    8.613239]  [<ffffffff816c6952>] ? kzalloc.constprop.14+0x10/0x10
> [    8.613239]  [<ffffffff816c6952>] ? kzalloc.constprop.14+0x10/0x10
> [    8.613239]  [<ffffffff81757a1d>] acpi_walk_namespace+0x98/0xcb
> [    8.613239]  [<ffffffff816c6dfe>] init_bridge_misc+0x4c/0xd5
> [    8.613239]  [<ffffffff816c6f70>] add_bridge+0xe9/0x138
> [    8.613239]  [<ffffffff817423c9>] acpi_pci_register_driver+0x52/0x79
> [    8.613239]  [<ffffffff838ce2b2>] ? shpcd_init+0xf0/0xf0
> [    8.613239]  [<ffffffff838ce34a>] acpiphp_glue_init+0x48/0x51
> [    8.613239]  [<ffffffff838ce2dd>] acpiphp_init+0x2b/0x50
> [    8.613239]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
> [    8.613239]  [<ffffffff8389ccef>] kernel_init+0x13c/0x1c0
> [    8.613239]  [<ffffffff8389c590>] ? do_early_param+0x8c/0x8c
> [    8.613239]  [<ffffffff82716944>] kernel_thread_helper+0x4/0x10
> [    8.613239]  [<ffffffff8270ee70>] ? retint_restore_args+0x13/0x13
> [    8.613239]  [<ffffffff8389cbb3>] ? start_kernel+0x3d1/0x3d1
> [    8.613239]  [<ffffffff82716940>] ? gs_change+0x13/0x13

Please check attached patch that should fix the problem.

-Yinghai

--0015175cd8620bfcb004ca432405
Content-Type: application/octet-stream; name="pci_root_bus_to_handle.patch"
Content-Disposition: attachment; filename="pci_root_bus_to_handle.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7e8tr6a2

U3ViamVjdDogW1BBVENIXSBQQ0ksIEFDUEksIHg4NiwgaWE2NDogVXNlIHBjaV9ob3N0X2JyaWRn
ZSBkZXYgdG8gc2F2ZSBhY3BpX2hhbmRsZQoKU28gd2UgY291bGQgYXZvaWQgY2FsbGluZyBhY3Bp
X2dldF9wY2lfcm9vdGJyaWRnZV9oYW5kbGUgdGhhdCBjb3VsZCBjYXVzZSBkZWFkbG9jay4KCm5v
biByb290IHBjaSBidXMgaXMgdXNpbmcgYnJpZGdlLT5kZXYgYXJjaGRhdGEuYWNwaV9oYW5kbGUu
CmZvciByb290IGJ1cyB0aGF0IGZpZWxkIGlzIG5vdCB1c2VkLCBjb3VsZCBqdXN0IHNhdmUgcm9v
dCBoYW5kbGUsIGFuZCBnZXQgdGhhdApsYXRlciB3aGVuIG5lZWQgdG8gZ2V0IHJvb3QgYnVzJ3Mg
aGFuZGxlLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgpD
YzogVG9ueSBMdWNrIDx0b255Lmx1Y2tAaW50ZWwuY29tPgpDYzogRmVuZ2h1YSBZdSA8ZmVuZ2h1
YS55dUBpbnRlbC5jb20+CkNjOiB4ODZAa2VybmVsLm9yZwpDYzogbGludXgtaWE2NEB2Z2VyLmtl
cm5lbC5vcmcKCi0tLQogYXJjaC9pYTY0L3BjaS9wY2kuYyAgICAgIHwgICAgMSArCiBhcmNoL3g4
Ni9wY2kvYWNwaS5jICAgICAgfCAgICAxICsKIGluY2x1ZGUvbGludXgvcGNpLWFjcGkuaCB8ICAg
MTUgKysrKysrKysrKy0tLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDUg
ZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2FyY2gvaWE2NC9wY2kvcGNpLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC9pYTY0L3BjaS9wY2kuYworKysgbGludXgtMi42
L2FyY2gvaWE2NC9wY2kvcGNpLmMKQEAgLTM4NSw2ICszODUsNyBAQCBwY2lfYWNwaV9zY2FuX3Jv
b3Qoc3RydWN0IGFjcGlfcGNpX3Jvb3QKIAkJcmV0dXJuIE5VTEw7CiAJfQogCisJcGJ1cy0+YnJp
ZGdlLT5hcmNoZGF0YS5hY3BpX2hhbmRsZSA9IGRldmljZS0+aGFuZGxlOwogCXBjaV9zY2FuX2No
aWxkX2J1cyhwYnVzKTsKIAlyZXR1cm4gcGJ1czsKIApJbmRleDogbGludXgtMi42L2FyY2gveDg2
L3BjaS9hY3BpLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvcGNpL2Fj
cGkuYworKysgbGludXgtMi42L2FyY2gveDg2L3BjaS9hY3BpLmMKQEAgLTUyMCw2ICs1MjAsNyBA
QCBzdHJ1Y3QgcGNpX2J1cyAqIF9fZGV2aW5pdCBwY2lfYWNwaV9zY2FuCiAJCQkJCQkgIHNkLCAm
cmVzb3VyY2VzKTsKIAogCQlpZiAoYnVzKSB7CisJCQlidXMtPmJyaWRnZS0+YXJjaGRhdGEuYWNw
aV9oYW5kbGUgPSBkZXZpY2UtPmhhbmRsZTsKIAkJCXBjaV9zY2FuX2NoaWxkX2J1cyhidXMpOwog
CQkJcGNpX3NldF9ob3N0X2JyaWRnZV9yZWxlYXNlKAogCQkJCXRvX3BjaV9ob3N0X2JyaWRnZShi
dXMtPmJyaWRnZSksCkluZGV4OiBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9wY2ktYWNwaS5oCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2luY2x1ZGUvbGludXgvcGNpLWFjcGkuaAorKysg
bGludXgtMi42L2luY2x1ZGUvbGludXgvcGNpLWFjcGkuaApAQCAtMjIsMTkgKzIyLDI0IEBAIGV4
dGVybiBwaHlzX2FkZHJfdCBhY3BpX3BjaV9yb290X2dldF9tY2YKIHN0YXRpYyBpbmxpbmUgYWNw
aV9oYW5kbGUgYWNwaV9maW5kX3Jvb3RfYnJpZGdlX2hhbmRsZShzdHJ1Y3QgcGNpX2RldiAqcGRl
dikKIHsKIAlzdHJ1Y3QgcGNpX2J1cyAqcGJ1cyA9IHBkZXYtPmJ1czsKKwogCS8qIEZpbmQgYSBQ
Q0kgcm9vdCBidXMgKi8KIAl3aGlsZSAoIXBjaV9pc19yb290X2J1cyhwYnVzKSkKIAkJcGJ1cyA9
IHBidXMtPnBhcmVudDsKLQlyZXR1cm4gYWNwaV9nZXRfcGNpX3Jvb3RicmlkZ2VfaGFuZGxlKHBj
aV9kb21haW5fbnIocGJ1cyksCi0JCQkJCSAgICAgIHBidXMtPm51bWJlcik7CisKKwlyZXR1cm4g
REVWSUNFX0FDUElfSEFORExFKHBidXMtPmJyaWRnZSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgYWNw
aV9oYW5kbGUgYWNwaV9wY2lfZ2V0X2JyaWRnZV9oYW5kbGUoc3RydWN0IHBjaV9idXMgKnBidXMp
CiB7CisJc3RydWN0IGRldmljZSAqZGV2OworCiAJaWYgKCFwY2lfaXNfcm9vdF9idXMocGJ1cykp
Ci0JCXJldHVybiBERVZJQ0VfQUNQSV9IQU5ETEUoJihwYnVzLT5zZWxmLT5kZXYpKTsKLQlyZXR1
cm4gYWNwaV9nZXRfcGNpX3Jvb3RicmlkZ2VfaGFuZGxlKHBjaV9kb21haW5fbnIocGJ1cyksCi0J
CQkJCSAgICAgIHBidXMtPm51bWJlcik7CisJCWRldiA9ICZwYnVzLT5zZWxmLT5kZXY7CisJZWxz
ZQorCQlkZXYgPSBwYnVzLT5icmlkZ2U7CisKKwlyZXR1cm4gREVWSUNFX0FDUElfSEFORExFKGRl
dik7CiB9CiAjZW5kaWYKIAo=
--0015175cd8620bfcb004ca432405--
