Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2KNLO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:14:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:50547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab2KNLOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:14:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,249,1352102400"; 
   d="p7s'?scan'208";a="246805453"
From: "Wei, Gang" <gang.wei@intel.com>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
CC: "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH v2] x86: add a new SMP bring up way for tboot case
Thread-Topic: [PATCH v2] x86: add a new SMP bring up way for tboot case
Thread-Index: AQHNp1ZItSePiogfZEWeT9AgjFvbB5fpY46A
Date: Wed, 14 Nov 2012 11:14:49 +0000
Message-ID: <D0B11485C64D4B47B66902F8A4E901BE3DC50F@SHSMSX101.ccr.corp.intel.com>
References: <1349950267-28328-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1349950267-28328-1-git-send-email-qiaowei.ren@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0023_01CDC29C.50D0F290"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_0023_01CDC29C.50D0F290
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Any comments on this patch?

Jimmy

Ren, Qiaowei wrote on=A02012-10-11:
> tboot provides a better AP wakeup mechanism based on cpu MWAIT feature
> for OS/VMM. With this mechanism, system will boot faster and will NOT
> require VT to be enabled. But it requires that OS/VMM must have =
support
> it, otherwise system can never boot up.
>=20
> Once this mechanism is enabled, tboot will put APs waiting in MWAIT
> loops before launching kernel. kernel can check the new flag field in =
v6
> tboot shared page for the hint. If the bit TB_FLAG_AP_WAKE_SUPPORT in
> flag field is set, kernel BSP has to write the monitored memory
> (tboot->ap_wake_trigger) to bring APs out of MWAIT loops. The sipi
> vector should be written in tboot->ap_wake_addr before waking up APs.
>=20
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
> Signed-off-by: Gang Wei <gang.wei@intel.com>
> ---
>  arch/x86/kernel/smpboot.c |   21 +++++++++++----------
>  arch/x86/kernel/tboot.c   |   17 +++++++++++++++++
>  include/linux/tboot.h     |   17 +++++++++++++++++
>  3 files changed, 45 insertions(+), 10 deletions(-)
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index c80a33b..884c3e7 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -662,8 +662,7 @@ static int __cpuinit do_boot_cpu(int apicid, int =
cpu,
> struct task_struct *idle)
>  	/* start_ip had better be page-aligned! */
>  	unsigned long start_ip =3D real_mode_header->trampoline_start;
> -	unsigned long boot_error =3D 0;
> -	int timeout;
> +	int timeout, boot_error =3D 0;
>=20
>  	/* Just in case we booted with a single CPU. */
>  	alternatives_enable_smp();
> @@ -710,14 +709,16 @@ static int __cpuinit do_boot_cpu(int apicid, int
cpu,
> struct task_struct *idle)
>  		}
>  	}
> -	/* -	 * Kick the secondary CPU. Use the method in the APIC driver
-	 *
> if it's defined - or use an INIT boot APIC message otherwise: -	 */
-	if
> (apic->wakeup_secondary_cpu) -		boot_error =3D
> apic->wakeup_secondary_cpu(apicid, start_ip); -	else -
boot_error =3D
> wakeup_secondary_cpu_via_init(apicid, start_ip); +	if
> (!tboot_wake_up(apicid, start_ip)) { +		/* +		 *
Kick the secondary CPU.
> Use the method in the APIC driver +		 * if it's defined - or use
an INIT
> boot APIC message otherwise: +		 */ +		if
(apic->wakeup_secondary_cpu)
> +			boot_error =3D apic->wakeup_secondary_cpu(apicid,
start_ip); +		else
> +			boot_error =3D wakeup_secondary_cpu_via_init(apicid,
start_ip); +	}
>=20
>  	if (!boot_error) {
>  		/*
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index f84fe00..e5e50b8 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -101,6 +101,8 @@ void __init tboot_probe(void)
>  	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
>  	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
>  	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
> +	if (tboot->version >=3D 6)
> +		pr_info("flags: 0x%08x\n", tboot->flags);
>  }
> =20
>  static pgd_t *tboot_pg_dir;
> @@ -453,3 +455,18 @@ int tboot_force_iommu(void)
>=20
>  	return 1;
>  }
> +
> +int tboot_wake_up(int apicid, unsigned long sipi_vec)
> +{
> +	if (!tboot_enabled())
> +		return 0;
> +
> +	if ((tboot->version < 6) ||
> +	    !(tboot->flags & TB_FLAG_AP_WAKE_SUPPORT))
> +		return 0;
> +
> +	tboot->ap_wake_addr =3D sipi_vec;
> +	tboot->ap_wake_trigger =3D apicid;
> +
> +	return 1;
> +}
> diff --git a/include/linux/tboot.h b/include/linux/tboot.h
> index c75128b..d65f7e9 100644
> --- a/include/linux/tboot.h
> +++ b/include/linux/tboot.h
> @@ -124,8 +124,23 @@ struct tboot {
>=20
>  	/* number of processors in wait-for-SIPI */
>  	u32 num_in_wfs;
> +
> +	/*
> +	 * version 6+ fields:
> +	 */
> +
> +	u32 flags;
> +
> +	/* phys addr of kernel/VMM SIPI vector */
> +	u64 ap_wake_addr;
> +
> +	/* kernel/VMM writes APIC ID to wake AP */
> +	u32 ap_wake_trigger;
>  } __packed;
> +/* kernel/VMM use INIT-SIPI-SIPI if clear, ap_wake_* if set */
> +#define TB_FLAG_AP_WAKE_SUPPORT 0X00000001
> +
>  /*
>   * UUID for tboot data struct to facilitate matching
>   * defined as {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} by tboot, which =
is
> @@ -146,6 +161,7 @@ extern void tboot_shutdown(u32 shutdown_type);
>  extern struct acpi_table_header *tboot_get_dmar_table(
>  				      struct acpi_table_header *dmar_tbl);
>  extern int tboot_force_iommu(void);
> +extern int tboot_wake_up(int apicid, unsigned long sipi_vec);
>=20
>  #else
> @@ -156,6 +172,7 @@ extern int tboot_force_iommu(void);
>  					do { } while (0)
>  #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
>  #define tboot_force_iommu()		0
> +#define tboot_wake_up(apicid, sipi_vec) 0
>=20
>  #endif /* !CONFIG_INTEL_TXT */

------=_NextPart_000_0023_01CDC29C.50D0F290
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIdxjCCAyAw
ggKJoAMCAQICBDXe9M8wDQYJKoZIhvcNAQEFBQAwTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0Vx
dWlmYXgxLTArBgNVBAsTJEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw05
ODA4MjIxNjQxNTFaFw0xODA4MjIxNjQxNTFaME4xCzAJBgNVBAYTAlVTMRAwDgYDVQQKEwdFcXVp
ZmF4MS0wKwYDVQQLEyRFcXVpZmF4IFNlY3VyZSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMFdsVhnCGLuoJotHwhtkRRomAoe/toEbxOEYiHD0XzOnwXg
uAHwTjTs4oqVBGSs8WtTXwWzy2eAv0ICjv7dAQns4QAUT/z78AzdQ7pbK+EfgHCZFVeTFvEPl2q3
wmgjHMxNWTCsUR47ryvW7mNFe8XZX1DS41APOojnvxT94Me5AgMBAAGjggEJMIIBBTBwBgNVHR8E
aTBnMGWgY6BhpF8wXTELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0VxdWlmYXgxLTArBgNVBAsTJEVx
dWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTENMAsGA1UEAxMEQ1JMMTAaBgNVHRAE
EzARgQ8yMDE4MDgyMjE2NDE1MVowCwYDVR0PBAQDAgEGMB8GA1UdIwQYMBaAFEjmaPkr0rKV10fY
IyAQTzOYkJ/UMB0GA1UdDgQWBBRI5mj5K9KylddH2CMgEE8zmJCf1DAMBgNVHRMEBTADAQH/MBoG
CSqGSIb2fQdBAAQNMAsbBVYzLjBjAwIGwDANBgkqhkiG9w0BAQUFAAOBgQBYzinq/Pfetc4CuRe1
hdG54+CVzCUxDQCmkm5/tpJjnlCV0Zpv5BHeY4VumO6o/1rI01WyZnFX3sAh6z0qpyNJAQSGQnv8
7n+iFlK1Z2fTQNs7JliyKHc9rhR3Ydb6KmYnoA36p3Nc6nDxlCFlRF/6/O8paKmih3nvee9PrAd3
ODCCAz0wggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UE
ChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
MB4XDTA2MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoT
EUludGVsIENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kg
Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATD
IsV2xDyt30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUj
ZzTZFq2N4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZv
uSQ0E11yYL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4
lz36wOdNZn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+
iC1HawJdAgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0
Vgaj7TdUDDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3Nl
Y3VyZWNhLmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69
tOkIP4SgDJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3j
Mfr900fXZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFijCCBHKgAwIBAgIKYR6AtwAA
AAAABzANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUx
OTI1MTNaFw0xNTA1MTUxOTM1MTNaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jw
b3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMGPgGLnOO5IOzlHRfr1XfCVb97V4BR2QVpPZ7Cr
cIQ+FGa2KHD/6dPjwxOIrtFTdfW4BYikdFmxUZVBWRWZ5Vye2cCdGzFWqIEOE1e17nNx1jM8Z6GZ
EqbDUS+vBuPlBFHKQoVm5BaNIHpyn2XZxqwjV9j5/crIfPrCGstk+2ztUhVS8OHEgzO784PgD9pO
gBnnAbZHmEM1FYYmQ6ibS+gVCHzobDYG+YReRiHpFKWBxpUuP+X0WYFw/Ja1JW7N8pELAFDw0UFB
WFgiv1QIusdLvSy8mcsLJ5wy050OVcxShqoUxhw/wvyuuoQxvmEPjhRa1C2oSCmGN0003GMhQWMC
AwEAAaOCAlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFKoWZq+3PVZTYK4Nwu3z7gfL
UWB+MAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBTCKwhT
x+hdMsKCgOmWwLgjQsAV+TAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQa
xgxKxEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3kl
MjBDQS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0lu
dGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYw
gdMwYwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNh
dGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcw
AoZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUA
A4IBAQCUY/1d0MS6VPTlIcOho1XWh193PD5kJDJSPdphLHQdM1oKA+whMdIBoY1VzTDDK+C+Ey4J
cyna7fpC8uVmn/Rz/i9MZtyc7qezPtZTn9UyORvJmddH+Ox/RycGwe3ags8jUdspECorYOkJyZks
nDIlTVUvbR7wyY+gGJYqxWXqrcVFEiMsWu8/OIlf7F2gAYMBw1kZ55dn4lWBIM0WqvReWpPvhYeN
7Y+3MKEdSMkQ7TZiNbfdZ5D/8KfWNMTJ4VHltOgCL1lA5tx/F4R1920skpL5eu3Sj650RUe3rOXs
aV5NyJzBwB31+1zsmleVdFD0k/Fw9HxXbAQE35ucN/7CMIIFijCCBHKgAwIBAgIKYSCKYgAAAAAA
CDANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRp
b24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUxOTI3
MjZaFw0xNTA1MTUxOTM3MjZaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3Jh
dGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKQEM1Wn9TU9vc9C+/Tc7KB+eiYElmrcEWE32WUdHvWG
+IcQHVQsikTmMyKKojNLw2B5s6Iekc8ivDo/wCfjZzX9JyftMnc+AArc0la87Olybzm8K9jXEfTB
vTnUSFSiI9ZYefITdiUgqlAFuljFZEHYKYtLuhrRacpmQfP4mV63NKdc2bT804HRf6YptZFa4k6Y
N94zlrGNrBuQQ74WFzz/jLBusbUpEkro6Mu/ZYFOFWQrV9lBhF9Ruk8yN+3N6n9fUo/qBigiF2kE
n9xVh1ykl7SCGL2jBUkXx4qgV27a6Si8lRRdgrHGtN/HWnSWlLXTH5l575H4Lq++77OFv38CAwEA
AaOCAlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFA7GKvdZsggQkCVvw939imYxMCvF
MAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQ5oFY2ekKQ
/5Ktim+VdMeSWb4QWTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQaxgxK
xEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3LmludGVs
LmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3klMjBD
QS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVs
JTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYwgdMw
YwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVz
L0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcwAoZg
aHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50
ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUAA4IB
AQCxtQEHchVQhXyjEqtMVUMe6gkmPsIczHxSeqNbo9dsD+6xbT65JT+oYgpIAtfEsYXeUJu1cChq
pb22U5bMAz7eaQcW5bzefufWvA6lg2048B8oczBj/q+5P5NpYrUO8jOmN4jTjfJq3ElZ7yFWpy7r
B3Vm/aN6ATYqWfMbS/xfh+JCxmH3droUmMJI0/aZJHsLtjbjFnNsHDNrJZX1vxlM78Lb1hjskTEN
PmhbVbfTj5i/ZGnhv4tmI8QZPCNtcegXJrfhRl2D9bWpdTOPrWiLDUqzy1Z6KL7TcOS/PCl8RHCJ
XkPau/thTQCpIoDa2+c+3XA++gRTfAQ4svTO260NMIIF+zCCBOOgAwIBAgIKHtX06gABAACWPTAN
BgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24x
KzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0IwHhcNMTIwNjA4MDgw
NTExWhcNMTUwNTE1MTkzNzI2WjA3MRIwEAYDVQQDEwlXZWksIEdhbmcxITAfBgkqhkiG9w0BCQEW
Emdhbmcud2VpQGludGVsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALNyfS4y
C6aDo3DZ/oId96Dvi8CB5SJyDUcMhpKWZtzqPX2mMOqQNgv4qAtHUjt4ibyPSjGZ+0EM3r63384g
GcVR8+uxiuijBIOCkis6oGQ+TmBl1i28KobkE4jNnLCES0keisfNdzO8vAOxIFbT9KxQl1f1Mfvs
ZfyGfFYB53gHCh1VxdZ7a2XKaON+l2YYx2p5xGGZtDDb61ajXSGvdHK+qMIfo7LMoZmY42t5Nawg
izwcqBPUOLR+JXOtyGGiXZx3wZPeRmZx/eCMPBhSlfewpvUrK8W0kL591Lv0HeUVEJye2bOmlLo1
DeIp6KH9JujFB33KhHXvNsugc9IYUVMCAwEAAaOCAugwggLkMAsGA1UdDwQEAwIHgDA8BgkrBgEE
AYI3FQcELzAtBiUrBgEEAYI3FQiGw4x1hJnlUYP9gSiFjp9TgpHACWeB3r05lfBDAgFkAgEIMB0G
A1UdDgQWBBQYdG5bBKSgjlBUQ6dpUm2vjlkEKDAfBgNVHSMEGDAWgBQOxir3WbIIEJAlb8Pd/Ypm
MTArxTCBzwYDVR0fBIHHMIHEMIHBoIG+oIG7hldodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0
b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQigxKS5j
cmyGYGh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIw
RXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCKDEpLmNybDCB9QYIKwYBBQUHAQEE
gegwgeUwbAYIKwYBBQUHMAKGYGh0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlm
aWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCKDEpLmNy
dDB1BggrBgEFBQcwAoZpaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9j
ZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0Io
MSkuY3J0MB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3CgMMMCkGCSsGAQQBgjcVCgQcMBow
CgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDDDBBBgNVHREEOjA4oCIGCisGAQQBgjcUAgOgFAwSZ2Fu
Zy53ZWlAaW50ZWwuY29tgRJnYW5nLndlaUBpbnRlbC5jb20wDQYJKoZIhvcNAQEFBQADggEBAHuy
cX8AxjwfC5zmWDh0QpY8vDSgyLXaUDYKm2+ATDJDn5kALJgxAqaThvqGTH+oz73HQ7L8v7QxM0Yp
1IQd/k5GeqMzhuXEoPM4rcORlOlvRqxBJNZUuYwxvyYaUpLU1W8EsOB2zB31ykzdXH93b6ZpfJk7
8eqZuq00xHxU9mw4PXlWPnn1NDBYD1JH/ufCmpFk6sBE2bBf2u2miBEwHoRUyoH1nbu78aOs4mE6
fRC9NutIriNPI2790R3FAY8dLWl3nrpXs80TrUCptat61uNRJDH06KXe81QCtvDVlBGbZ4gqWR3P
ZGsnJKeOLOO38PQvFFm1Xjs4DVYiPVYyCTIwggZCMIIFKqADAgECAgoUmebGAAEAAFPVMA0GCSqG
SIb3DQEBBQUAMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkG
A1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQTAeFw0xMDEyMDEwOTMxMzla
Fw0xMzExMTUwOTMxMzlaMDcxEjAQBgNVBAMTCVdlaSwgR2FuZzEhMB8GCSqGSIb3DQEJARYSZ2Fu
Zy53ZWlAaW50ZWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlkDjEHBe0Gg1
dZhmebTYRY4qWGcBCKuEGfp8DuoVXyv3gW6bXc8TcWRSXj0vxL/+/RKObwVc17Cu2XcO0MTU1EOo
ohTEl/QDnBvj0qeqKnkZGmAM0cCU7+m07N0ATPEzg0t2gJUA8dVO37iAo1KMQ72ovMJ1LU+x7tno
d6PhrgXLmbjkEjQZnHwLvuI2TdiKKDvJtd6xz6DQuIBSPyn4wYsckGQcb5NlEiQCkCaPM/ZtcKcm
Kxu0g1TfW7zIWuRhkPIOyin/bsN8RBTTq8lL74yFgTB4ybAMp13wtROVAN5FLYE31CAgJ69EBNix
xTBNsLtv+KM6sXsbDccp3H5JwQIDAQABo4IDLzCCAyswCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcV
BwQwMC4GJisGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgEMMEQGCSqG
SIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggq
hkiG9w0DBzAdBgNVHQ4EFgQUwmKbKrf26Ot7Acv/+2aZDzj7gaQwHwYDVR0jBBgwFoAUqhZmr7c9
VlNgrg3C7fPuB8tRYH4wgc8GA1UdHwSBxzCBxDCBwaCBvqCBu4ZXaHR0cDovL3d3dy5pbnRlbC5j
b20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwM0EoMSkuY3JshmBodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NS
TC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQSgxKS5jcmwwgfUG
CCsGAQUFBwEBBIHoMIHlMGwGCCsGAQUFBzAChmBodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0
b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0El
MjAzQSgxKS5jcnQwdQYIKwYBBQUHMAKGaWh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3Vpbmcl
MjBDQSUyMDNBKDEpLmNydDAfBgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEE
AYI3FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwQwQQYDVR0RBDowOKAiBgorBgEEAYI3
FAIDoBQMEmdhbmcud2VpQGludGVsLmNvbYESZ2FuZy53ZWlAaW50ZWwuY29tMA0GCSqGSIb3DQEB
BQUAA4IBAQAPFjqbkKIbnvnYwFG/QpKUm2yGzieys9IJny7PU2fVV4ksTL7emcpCfhFtlg7cPEgU
7Rx6gG4hO+ZBx9oojImSGWj44Pj3EzSyRRaN+UK1VVESHgE2HKmETsAnRN/wulP9ahPJNmEOklBg
oX6BJg9NYTqp8gDS6m1QBQoh/C2/51MGcmTecM4g5BuEpgmvxovlPDHlnSq390NXwXtdh1lM5qbo
V9FBWFCR1Q7mf7n2Y6b/9m9bn9gMzbdwjMrnpYIiC5rN5WBDQtuzAios8OheGSTX0A1npuGZ3cvP
NlPbRAoD7TVAdGhr+ZztVLA0+IFYmQqHV2C8q3TybgPnp1/uMYIDhjCCA4ICAQEwZDBWMQswCQYD
VQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVy
bmFsIEJhc2ljIElzc3VpbmcgQ0EgM0ICCh7V9OoAAQAAlj0wCQYFKw4DAhoFAKCCAfcwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTIxMTE0MTExNDQ5WjAjBgkqhkiG
9w0BCQQxFgQUZ0Kodj8EWA6Ml6KTsGtwTLHqZSAwcwYJKwYBBAGCNxAEMWYwZDBWMQswCQYDVQQG
EwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFs
IEJhc2ljIElzc3VpbmcgQ0EgM0ECChSZ5sYAAQAAU9UwdQYLKoZIhvcNAQkQAgsxZqBkMFYxCzAJ
BgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0
ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQQIKFJnmxgABAABT1TCBqwYJKoZIhvcNAQkPMYGdMIGa
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCgYIKoZIhvcNAwcwCwYJYIZIAWUDBAECMA4GCCqG
SIb3DQMCAgIAgDAHBgUrDgMCBzANBggqhkiG9w0DAgIBQDANBggqhkiG9w0DAgIBKDAHBgUrDgMC
GjALBglghkgBZQMEAgMwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASC
AQBlRS9W6rsqqaRL6ENeEpeAys0sn5cD2wJgn59hDObHjw9vVPteeGxbfiitRoKpOxh7qAO4+1aX
zHRWMPxs9XAj1sdjfqk9Mc2YsBki3DPvA+McDlpIabGdB11xLmwsoHabrFLrnq+ipdoFCA3tRxE9
tR1dP2TgSvymsvGlvWwcCTq4M4bs/Heyu/mjKgFwHws9Cl2POR8RX5c9qExRyJrRI2P+Xek0kONc
koX3mLJg0+XrcI5p0/pFt/ZNruprJIpU1gAq0f47Wb8y+FO5CA+/zupWgsmaOLRqaT5iCqR1hwJ4
eBHT5U9N13ux1W8ixUy7qt/zbVhUIfCq1tIoOcYzAAAAAAAA

------=_NextPart_000_0023_01CDC29C.50D0F290--
