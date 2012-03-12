Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2CLIPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:15:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:13771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab2CLIPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:15:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="p7s'?scan'208";a="117648721"
From: "Mansoor, Illyas" <illyas.mansoor@intel.com>
To: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: "Hunter, Adrian" <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: mmc: sdhci-pci: why no .shutdown() implemented
Thread-Topic: mmc: sdhci-pci: why no .shutdown() implemented
Thread-Index: Ac0AKE1jpwMlC3NvQ4an3MJTEam5qA==
Date: Mon, 12 Mar 2012 08:15:37 +0000
Message-ID: <810586B7581CC8469141DADEBC3719120AECF8@BGSMSX102.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_03B1_01CD0056.67A47130"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_03B1_01CD0056.67A47130
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi All,

I'm not sure if this is the right mailing list to discuss this question, but
anyways I'll ask:

On our platform we implemented a BUG in pci_set_power_state callback when the
shutdown
Is in progress, and we caught sdci-pci doing pci_set_power_state(D0) when
shutdown was
Already in progress.

My question, why doesn't sdhci-pci.c implement a .shutdown() callback and close
the device
After doing sys_sync()?

Is there some reason behind it not doing a graceful shutdown.

I think it could cause corruption, since there is no guarantee when the system
will power-off/reboot/halt

I just implemented a patch to fix this, if it's a good fix I'll submit.

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index f5fe05c..e0818c9 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -23,6 +23,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/async.h>
+#include <linux/syscalls.h>

 #include <asm/scatterlist.h>
 #include <asm/io.h>
@@ -1342,6 +1343,34 @@ err:
        return ret;
 }

+static void sdhci_pci_shutdown(struct pci_dev *pdev)
+{
+       int i;
+       struct sdhci_pci_chip *chip;
+
+       printk(KERN_INFO "%s: Syncing filesystems ... ", __func__);
+       sys_sync();
+       printk("done.\n");
+
+       pm_runtime_get_sync(&pdev->dev);
+
+       chip = pci_get_drvdata(pdev);
+
+       if (chip) {
+               for (i = 0;i < chip->num_slots; i++)
+                       sdhci_pci_remove_slot(chip->slots[i]);
+
+               pci_set_drvdata(pdev, NULL);
+               kfree(chip);
+       }
+
+       pci_disable_device(pdev);
+
+       pm_runtime_put_noidle(&pdev->dev);
+       pm_runtime_forbid(&pdev->dev);
+       pm_runtime_disable(&pdev->dev);
+}
+
 static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
 {
        int i;
@@ -1473,6 +1502,7 @@ static struct pci_driver sdhci_driver = {
        .id_table =     pci_ids,
        .probe =        sdhci_pci_probe,
        .remove =       __devexit_p(sdhci_pci_remove),
+       .shutdown =     sdhci_pci_shutdown,


-Illyas

------=_NextPart_000_03B1_01CD0056.67A47130
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYaDCCAyAw
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
Mfr900fXZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFijCCBHKgAwIBAgIKYSCKYgAA
AAAACDANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUx
OTI3MjZaFw0xNTA1MTUxOTM3MjZaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jw
b3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKQEM1Wn9TU9vc9C+/Tc7KB+eiYElmrcEWE32WUd
HvWG+IcQHVQsikTmMyKKojNLw2B5s6Iekc8ivDo/wCfjZzX9JyftMnc+AArc0la87Olybzm8K9jX
EfTBvTnUSFSiI9ZYefITdiUgqlAFuljFZEHYKYtLuhrRacpmQfP4mV63NKdc2bT804HRf6YptZFa
4k6YN94zlrGNrBuQQ74WFzz/jLBusbUpEkro6Mu/ZYFOFWQrV9lBhF9Ruk8yN+3N6n9fUo/qBigi
F2kEn9xVh1ykl7SCGL2jBUkXx4qgV27a6Si8lRRdgrHGtN/HWnSWlLXTH5l575H4Lq++77OFv38C
AwEAAaOCAlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFA7GKvdZsggQkCVvw939imYx
MCvFMAsGA1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQ5oFY2
ekKQ/5Ktim+VdMeSWb4QWTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQa
xgxKxEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3kl
MjBDQS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0lu
dGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYw
gdMwYwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNh
dGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcw
AoZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUA
A4IBAQCxtQEHchVQhXyjEqtMVUMe6gkmPsIczHxSeqNbo9dsD+6xbT65JT+oYgpIAtfEsYXeUJu1
cChqpb22U5bMAz7eaQcW5bzefufWvA6lg2048B8oczBj/q+5P5NpYrUO8jOmN4jTjfJq3ElZ7yFW
py7rB3Vm/aN6ATYqWfMbS/xfh+JCxmH3droUmMJI0/aZJHsLtjbjFnNsHDNrJZX1vxlM78Lb1hjs
kTENPmhbVbfTj5i/ZGnhv4tmI8QZPCNtcegXJrfhRl2D9bWpdTOPrWiLDUqzy1Z6KL7TcOS/PCl8
RHCJXkPau/thTQCpIoDa2+c+3XA++gRTfAQ4svTO260NMIIGEzCCBPugAwIBAgIKFWACkwABAACH
wDANBgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRp
b24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0IwHhcNMTIwMTI2
MDY0MzEzWhcNMTUwMTEwMDY0MzEzWjBDMRgwFgYDVQQDEw9NYW5zb29yLCBJbGx5YXMxJzAlBgkq
hkiG9w0BCQEWGGlsbHlhcy5tYW5zb29yQGludGVsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAOLKk+CT5hEwsQdwos/OqCkUifVuyWoby0kGe6UsisRLKMgdFJQRcbEZc854jPbe
8YISCDRl1hTBq+vT9ZRwm7sStOI93WJF6Ob66+A12bab8qgSw6HLjYErSnXwLtrj2y+zScrNaSRJ
Xr+m59nIxba+8NvudUJ1FX0WQVmQFnCuJylzko8GPhFQBDmRQnwRCX0VJM/lJQOZOqQr5MoARNYN
V1A5mvEqMS2Hfe8qrfkaO2alLgC7tg36U78OhOwfIDW9MWkqtoVY7PT+WVfZ9UbUUwI+eWzPwPmz
KbouW0RA7PBva7AYQnFnbvFqBsDfiNhbccADYudqsvnyek1SaQECAwEAAaOCAvQwggLwMAsGA1Ud
DwQEAwIHgDA8BgkrBgEEAYI3FQcELzAtBiUrBgEEAYI3FQiGw4x1hJnlUYP9gSiFjp9TgpHACWeB
3r05lfBDAgFkAgEIMB0GA1UdDgQWBBSSPPfdaC41Y8K1RPfESldXb64J4jAfBgNVHSMEGDAWgBQO
xir3WbIIEJAlb8Pd/YpmMTArxTCBzwYDVR0fBIHHMIHEMIHBoIG+oIG7hldodHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5n
JTIwQ0ElMjAzQigxKS5jcmyGYGh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRv
cnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCKDEpLmNy
bDCB9QYIKwYBBQUHAQEEgegwgeUwbAYIKwYBBQUHMAKGYGh0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3Vpbmcl
MjBDQSUyMDNCKDEpLmNydDB1BggrBgEFBQcwAoZpaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5j
b20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNz
dWluZyUyMENBJTIwM0IoMSkuY3J0MB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3CgMMMCkG
CSsGAQQBgjcVCgQcMBowCgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDDDBNBgNVHREERjBEoCgGCisG
AQQBgjcUAgOgGgwYaWxseWFzLm1hbnNvb3JAaW50ZWwuY29tgRhpbGx5YXMubWFuc29vckBpbnRl
bC5jb20wDQYJKoZIhvcNAQEFBQADggEBAFPpw1PlHMUQjyxONBjYnTRfozVus7KykXMaZQWTVGIc
oeF9H7V0tzl0wB3z1bD21t91rWsDoAZOB6kxjz7i01a6mR8OHv341m8818/kgC8LQglZnDWDHdxY
Hp3vDu+o6QwH7CVVSf6ymi/6aihQCWLZRctSEvXvXx4K/SGkFGNMlKm5RDV+htQ5KDfk9T9LVr3W
lW69t3Wf3Tsm5qy1v5QczGFwZqCca/67ghrwP8dYhp9Ir9bqocJcdZYjWmZEDPz/3fj6PXxxdh2F
vOCy32HDBE6L796BVOiI9d4bbxuTcoUmL53sF6r7lNpImt4ASlnnkQRcR1rrWPJXC6H7lEwwggZa
MIIFQqADAgECAgoVZHP3AAEAAIfBMA0GCSqGSIb3DQEBBQUAMFYxCzAJBgNVBAYTAlVTMRowGAYD
VQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNz
dWluZyBDQSAzQjAeFw0xMjAxMjYwNjQ4MDVaFw0xNTAxMTAwNjQ4MDVaMEMxGDAWBgNVBAMTD01h
bnNvb3IsIElsbHlhczEnMCUGCSqGSIb3DQEJARYYaWxseWFzLm1hbnNvb3JAaW50ZWwuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgvl4tjFKG7qkJ5HgPVOntL0NZCDa1tfKb8hT
zbHPlqLaiRAZJd/QjJcvMVMNhnk2BqpUk7564Xi4WK8Xb/qGBScfGmNRgD6rusizYoB6WrN1Fg9A
LhlZQygA24tsm5MspWOafPCrgDY8OLgC+48GdWzWYxtEB+f8qM8n3s1JQ/fRQqRsvei4vcyNce/S
wlIlYJH0EyeJuR3sMpShZdexnfnArSkttheYo8tnL6TT/SqXZ4C51AXiV4cU6z7DNPTx0Ae24UnD
eAtvsoKiqds//Wk9gk4qoaF5IhXevz2PcG3zqGgvt0pTDj79Umb4mza8EmtUc2UtliBnhXo+qVv1
3QIDAQABo4IDOzCCAzcwCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIbD
jHWEmeVRg/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgEMMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZI
hvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQU
UkdcLiBuK8C6TP9mVRypaDJDFlUwHwYDVR0jBBgwFoAUDsYq91myCBCQJW/D3f2KZjEwK8Uwgc8G
A1UdHwSBxzCBxDCBwaCBvqCBu4ZXaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0IoMSkuY3JshmBodHRw
Oi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQigxKS5jcmwwgfUGCCsGAQUFBwEBBIHoMIHlMGwG
CCsGAQUFBzAChmBodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9J
bnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQigxKS5jcnQwdQYIKwYB
BQUHMAKGaWh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNh
dGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCKDEpLmNydDAf
BgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUF
BwMEMAwGCisGAQQBgjcKAwQwTQYDVR0RBEYwRKAoBgorBgEEAYI3FAIDoBoMGGlsbHlhcy5tYW5z
b29yQGludGVsLmNvbYEYaWxseWFzLm1hbnNvb3JAaW50ZWwuY29tMA0GCSqGSIb3DQEBBQUAA4IB
AQBEffGupAfAE+Y5L+hlXS1UW0TEDOnQBq3uypJmipQTm+b6rDUeaME1HSPqk0N640yUFZYO9wr4
3QeVWksRsIz7jxB7u7byd2sou8Z9Gx57o79FC3UCvmTWn0+Au2+klUdqi5ZyawlxPkwJyG0/oaKQ
CABK3zUgLxhIv0d007LHgoyv4+jSPETqYlofCffG1pxEquL50D08k+W2x1GEkxqgASMqneT6FKJz
nYijxwnZz4mnHAnFc8KFJnmzsb3GkrcKAtBXYbux0Jbp/ZVdgyKzrensNsUMG2p6lPLSXcs5Pmlt
95t1h2XcwOThPPvE6lumj8IXDJwEbyrbUeqCli3IMYIDhjCCA4ICAQEwZDBWMQswCQYDVQQGEwJV
UzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJh
c2ljIElzc3VpbmcgQ0EgM0ICChVgApMAAQAAh8AwCQYFKw4DAhoFAKCCAfcwGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTIwMzEyMDgxNTM2WjAjBgkqhkiG9w0BCQQx
FgQUt3wbPi0Nei9x6NG0Z/8BdiCIEMgwcwYJKwYBBAGCNxAEMWYwZDBWMQswCQYDVQQGEwJVUzEa
MBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2lj
IElzc3VpbmcgQ0EgM0ICChVkc/cAAQAAh8EwdQYLKoZIhvcNAQkQAgsxZqBkMFYxCzAJBgNVBAYT
AlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwg
QmFzaWMgSXNzdWluZyBDQSAzQgIKFWRz9wABAACHwTCBqwYJKoZIhvcNAQkPMYGdMIGaMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEARYwCgYIKoZIhvcNAwcwCwYJYIZIAWUDBAECMA4GCCqGSIb3DQMC
AgIAgDAHBgUrDgMCBzANBggqhkiG9w0DAgIBQDANBggqhkiG9w0DAgIBKDAHBgUrDgMCGjALBglg
hkgBZQMEAgMwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQANO9hf
S8l9jIWZzgdNAsBYfvhN+J6W7OmnnQ7KeUFD+SeXYXKVjW6K8DixWZTHXL3HZc0zgjoZZy8iofVw
mvuJdHsjKmbEF3WUd7ktCgxNhf4H8cCjChX7yvEPyn8v7H2hjzzFX716NFOTch8Crrh7Plcl8iX9
gSc9jMNvRIOIGPakG9RWzVRkMYshQIkHMzGNnOrqum7qzmGyFUfAqZMPH11TZrsibJdvQM81rYH+
G4Ls2m0O9tUizVMivePyQptulgMkt0BlNNgHqzfXrySO5jtGViXGTXG0SCQ4WcZj95Gt6yAHqH6m
25Lnrk55f+Ubi/u7qYNO4OKbYH/aURZZAAAAAAAA

------=_NextPart_000_03B1_01CD0056.67A47130--
